###############################################################################
# Modulo: ecs
# Despliega el juego en AWS ECS Fargate detras de un Application Load Balancer.
# Incluye: cluster ECS, task definition, service, ALB, target group, listener,
# security groups, roles IAM y grupo de logs en CloudWatch.
###############################################################################

# Nombres de ALB y Target Group: AWS limita a 32 caracteres, por eso el substr.
locals {
  alb_name          = substr("${var.name_prefix}-alb", 0, 32)
  target_group_name = substr("${var.name_prefix}-tg", 0, 32)
}

# Grupo de logs donde el contenedor envia su salida (stdout/stderr).
resource "aws_cloudwatch_log_group" "app" {
  name              = "/ecs/${var.name_prefix}"
  retention_in_days = var.log_retention_days

  tags = var.tags
}

# Politica de confianza: permite que las tareas ECS asuman los roles IAM.
data "aws_iam_policy_document" "ecs_tasks_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

# Rol de ejecucion: lo usa ECS para descargar la imagen de ECR y escribir logs.
resource "aws_iam_role" "task_execution" {
  name                  = "${var.name_prefix}-ecs-execution"
  assume_role_policy    = data.aws_iam_policy_document.ecs_tasks_assume_role.json
  force_detach_policies = true

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "task_execution" {
  role       = aws_iam_role.task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Rol de la tarea: identidad que usa la app dentro del contenedor (permisos propios).
resource "aws_iam_role" "task" {
  name                  = "${var.name_prefix}-ecs-task"
  assume_role_policy    = data.aws_iam_policy_document.ecs_tasks_assume_role.json
  force_detach_policies = true

  tags = var.tags
}

# Security group del ALB: acepta trafico HTTP desde internet.
resource "aws_security_group" "alb" {
  name        = "${var.name_prefix}-alb-sg"
  description = "Permite trafico HTTP entrante al Application Load Balancer."
  vpc_id      = var.vpc_id

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-alb-sg"
  })
}

resource "aws_vpc_security_group_ingress_rule" "alb_http" {
  security_group_id = aws_security_group.alb.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = var.listener_port
  to_port           = var.listener_port
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "alb_all" {
  security_group_id = aws_security_group.alb.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # todo el trafico saliente
}

# Security group de las tareas: solo acepta trafico proveniente del ALB.
resource "aws_security_group" "tasks" {
  name        = "${var.name_prefix}-tasks-sg"
  description = "Permite trafico desde el ALB hacia las tareas ECS."
  vpc_id      = var.vpc_id

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-tasks-sg"
  })
}

resource "aws_vpc_security_group_ingress_rule" "tasks_from_alb" {
  security_group_id            = aws_security_group.tasks.id
  referenced_security_group_id = aws_security_group.alb.id
  from_port                    = var.container_port
  to_port                      = var.container_port
  ip_protocol                  = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "tasks_all" {
  security_group_id = aws_security_group.tasks.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

# Application Load Balancer: punto de entrada publico, distribuido en varias AZ.
resource "aws_lb" "app" {
  name               = local.alb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = var.alb_subnet_ids

  enable_deletion_protection = var.enable_deletion_protection

  tags = merge(var.tags, {
    Name = local.alb_name
  })
}

# Target group: agrupa las tareas (target_type ip por usar red awsvpc/Fargate).
resource "aws_lb_target_group" "app" {
  name        = local.target_group_name
  port        = var.container_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  deregistration_delay = 30

  health_check {
    enabled             = true
    healthy_threshold   = 2
    interval            = 30
    matcher             = "200-399"
    path                = var.health_check_path
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 3
  }

  tags = merge(var.tags, {
    Name = local.target_group_name
  })
}

# Listener HTTP: recibe en el puerto publico y reenvia al target group.
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app.arn
  port              = var.listener_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }

  tags = var.tags
}

# Cluster ECS: agrupacion logica donde corren los servicios/tareas del juego.
resource "aws_ecs_cluster" "this" {
  name = "${var.name_prefix}-cluster"

  setting {
    name  = "containerInsights"
    value = var.container_insights
  }

  tags = var.tags
}

# Task definition: plantilla del contenedor (imagen, CPU/memoria, puertos, logs).
resource "aws_ecs_task_definition" "app" {
  family                   = "${var.name_prefix}-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  execution_role_arn       = aws_iam_role.task_execution.arn
  task_role_arn            = aws_iam_role.task.arn

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  container_definitions = jsonencode([
    {
      name      = var.container_name
      image     = var.container_image
      essential = true

      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.container_port
          protocol      = "tcp"
        }
      ]

      environment = [
        for name, value in var.environment_variables : {
          name  = name
          value = value
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.app.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = var.container_name
        }
      }
    }
  ])

  tags = var.tags
}

# Service ECS: mantiene corriendo N tareas del juego y las registra en el ALB.
# Las tareas viven en las subredes del juego (Subnet A), el ALB abarca todas.
resource "aws_ecs_service" "app" {
  name             = "${var.name_prefix}-service"
  cluster          = aws_ecs_cluster.this.id
  task_definition  = aws_ecs_task_definition.app.arn
  desired_count    = var.desired_count
  launch_type      = "FARGATE"
  platform_version = "LATEST"

  enable_ecs_managed_tags = true
  enable_execute_command  = var.enable_execute_command
  propagate_tags          = "SERVICE"

  network_configuration {
    assign_public_ip = var.assign_public_ip
    security_groups  = [aws_security_group.tasks.id]
    subnets          = var.service_subnet_ids
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.app.arn
    container_name   = var.container_name
    container_port   = var.container_port
  }

  # Circuit breaker: si un despliegue falla, hace rollback automatico.
  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  health_check_grace_period_seconds = var.health_check_grace_period_seconds

  # Evita condiciones de carrera: el listener y los permisos deben existir antes.
  depends_on = [
    aws_iam_role_policy_attachment.task_execution,
    aws_lb_listener.http
  ]

  tags = var.tags
}

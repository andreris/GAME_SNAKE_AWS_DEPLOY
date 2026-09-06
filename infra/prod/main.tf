###############################################################################
# Composicion: prod
# Une los modulos de red y ECS para desplegar el juego "viborita" en AWS.
# Arquitectura (segun el diagrama):
#   AWS Account > VPC > Subnet A (Juego / Cluster ECS) + Subnet B (Otro tema)
###############################################################################

locals {
  name_prefix = "${var.project_name}-${var.environment}"

  common_tags = merge(var.tags, {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  })

  # Imagen que desplegara ECS: repositorio ECR creado aqui + tag elegido.
  # El CI/CD futuro solo hace push de un nuevo tag y ECS toma esta referencia.
  container_image = "${module.ecr.repository_url}:${var.image_tag}"
}

# Registro de contenedores: guarda las distintas versiones de la imagen del juego.
module "ecr" {
  source = "../modules/ecr"

  repository_name = local.name_prefix
  force_delete    = var.ecr_force_delete
  max_image_count = var.ecr_max_image_count
  tags            = local.common_tags
}

# Red base: VPC, subredes publicas (A y B), IGW y rutas.
module "networking" {
  source = "../modules/networking"

  project_name   = var.project_name
  environment    = var.environment
  vpc_cidr       = var.vpc_cidr
  public_subnets = var.public_subnets
  tags           = local.common_tags
}

# Plataforma de contenedores: cluster ECS, servicio Fargate, ALB y observabilidad.
# - El ALB abarca todas las subredes publicas (requiere >= 2 AZ).
# - Las tareas del juego corren solo en la Subnet A (Juego).
module "ecs" {
  source = "../modules/ecs"

  name_prefix = local.name_prefix
  aws_region  = var.aws_region
  vpc_id      = module.networking.vpc_id

  alb_subnet_ids     = module.networking.public_subnet_ids
  service_subnet_ids = [module.networking.public_subnet_ids_by_name[var.game_subnet_name]]

  container_image       = local.container_image
  container_port        = var.container_port
  desired_count         = var.desired_count
  task_cpu              = var.task_cpu
  task_memory           = var.task_memory
  health_check_path     = var.health_check_path
  log_retention_days    = var.log_retention_days
  environment_variables = var.environment_variables

  tags = local.common_tags
}

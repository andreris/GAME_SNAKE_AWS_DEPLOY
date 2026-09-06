variable "name_prefix" {
  description = "Prefijo de nombres para los recursos (ej. viborita-prod)."
  type        = string
}

variable "aws_region" {
  description = "Region de AWS (usada por el log driver awslogs)."
  type        = string
}

variable "vpc_id" {
  description = "ID de la VPC donde se despliega el servicio."
  type        = string
}

variable "alb_subnet_ids" {
  description = "Subredes publicas donde vive el ALB (minimo 2 AZ)."
  type        = list(string)
}

variable "service_subnet_ids" {
  description = "Subredes donde corren las tareas del juego (Subnet A)."
  type        = list(string)
}

variable "container_image" {
  description = "Imagen del contenedor a desplegar (URI de ECR con tag)."
  type        = string
}

variable "container_name" {
  description = "Nombre logico del contenedor dentro de la task."
  type        = string
  default     = "viborita"
}

variable "container_port" {
  description = "Puerto que expone el contenedor (Gunicorn escucha 8000)."
  type        = number
  default     = 8000
}

variable "listener_port" {
  description = "Puerto publico del ALB."
  type        = number
  default     = 80
}

variable "desired_count" {
  description = "Numero de tareas a mantener corriendo."
  type        = number
  default     = 2
}

variable "task_cpu" {
  description = "CPU de la tarea Fargate (256 = 0.25 vCPU)."
  type        = number
  default     = 256
}

variable "task_memory" {
  description = "Memoria de la tarea Fargate en MiB."
  type        = number
  default     = 512
}

variable "health_check_path" {
  description = "Ruta usada por el health check del target group."
  type        = string
  default     = "/"
}

variable "log_retention_days" {
  description = "Dias de retencion de los logs en CloudWatch."
  type        = number
  default     = 14
}

variable "assign_public_ip" {
  description = "Asignar IP publica a las tareas (true en subredes publicas)."
  type        = bool
  default     = true
}

variable "environment_variables" {
  description = "Variables de entorno inyectadas en el contenedor."
  type        = map(string)
  default     = {}
}

variable "container_insights" {
  description = "Habilita CloudWatch Container Insights en el cluster."
  type        = string
  default     = "enabled"
}

variable "enable_execute_command" {
  description = "Permite abrir shell en las tareas con ECS Exec (debug)."
  type        = bool
  default     = false
}

variable "enable_deletion_protection" {
  description = "Protege el ALB contra borrado accidental."
  type        = bool
  default     = false
}

variable "health_check_grace_period_seconds" {
  description = "Periodo de gracia antes de evaluar health checks en tareas nuevas."
  type        = number
  default     = 60
}

variable "tags" {
  description = "Etiquetas comunes aplicadas a todos los recursos."
  type        = map(string)
  default     = {}
}

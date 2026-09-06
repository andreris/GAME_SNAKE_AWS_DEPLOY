variable "aws_region" {
  description = "Region de AWS donde se despliega el juego."
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "Perfil local de AWS CLI. Dejar vacio en CI/CD (usa variables de entorno via OIDC)."
  type        = string
  default     = ""
}

variable "project_name" {
  description = "Nombre del proyecto (prefijo de naming)."
  type        = string
  default     = "viborita"
}

variable "environment" {
  description = "Entorno de despliegue."
  type        = string
  default     = "prod"
}

variable "vpc_cidr" {
  description = "CIDR de la VPC."
  type        = string
  default     = "10.10.0.0/16"
}

variable "public_subnets" {
  description = "Subredes publicas: Subnet A (juego) y Subnet B (otro tema)."
  type = list(object({
    name              = string
    cidr              = string
    availability_zone = string
  }))
  default = [
    {
      name              = "subnet-a-juego"
      cidr              = "10.10.1.0/24"
      availability_zone = "us-east-1a"
    },
    {
      name              = "subnet-b-otro-tema"
      cidr              = "10.10.2.0/24"
      availability_zone = "us-east-1b"
    }
  ]
}

variable "game_subnet_name" {
  description = "Nombre de la subred donde corren las tareas del juego (Subnet A)."
  type        = string
  default     = "subnet-a-juego"
}

# El repositorio ECR lo crea Terraform; aqui solo eliges que tag desplegar.
# El CI/CD futuro hara push de la imagen y ECS tomara este tag (ej. latest).
variable "image_tag" {
  description = "Tag de la imagen en ECR a desplegar (ej. latest o 1.0.0)."
  type        = string
  default     = "latest"
}

variable "ecr_force_delete" {
  description = "Permitir borrar el repositorio ECR aunque contenga imagenes."
  type        = bool
  default     = true
}

variable "ecr_max_image_count" {
  description = "Numero maximo de imagenes a conservar en ECR."
  type        = number
  default     = 10
}

variable "container_port" {
  description = "Puerto que expone el contenedor (Gunicorn)."
  type        = number
  default     = 8000
}

variable "desired_count" {
  description = "Numero de tareas del juego a mantener corriendo."
  type        = number
  default     = 2
}

variable "task_cpu" {
  description = "CPU de la tarea Fargate."
  type        = number
  default     = 256
}

variable "task_memory" {
  description = "Memoria de la tarea Fargate (MiB)."
  type        = number
  default     = 512
}

variable "health_check_path" {
  description = "Ruta del health check del ALB."
  type        = string
  default     = "/"
}

variable "log_retention_days" {
  description = "Dias de retencion de logs en CloudWatch."
  type        = number
  default     = 14
}

variable "environment_variables" {
  description = "Variables de entorno para el contenedor."
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Etiquetas adicionales para los recursos."
  type        = map(string)
  default     = {}
}

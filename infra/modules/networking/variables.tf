variable "project_name" {
  description = "Nombre del proyecto, usado como prefijo de nombres (ej. viborita)."
  type        = string
}

variable "environment" {
  description = "Entorno de despliegue (ej. prod)."
  type        = string
}

variable "vpc_cidr" {
  description = "Rango CIDR de la VPC."
  type        = string
}

variable "public_subnets" {
  description = "Lista de subredes publicas a crear (nombre, CIDR y zona de disponibilidad)."
  type = list(object({
    name              = string
    cidr              = string
    availability_zone = string
  }))
}

variable "tags" {
  description = "Etiquetas comunes aplicadas a todos los recursos."
  type        = map(string)
  default     = {}
}

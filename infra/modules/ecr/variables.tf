variable "repository_name" {
  description = "Nombre del repositorio ECR (ej. viborita-prod)."
  type        = string
}

variable "image_tag_mutability" {
  description = "Mutabilidad de los tags. MUTABLE permite resubir el mismo tag; IMMUTABLE lo bloquea."
  type        = string
  default     = "MUTABLE"

  validation {
    condition     = contains(["MUTABLE", "IMMUTABLE"], var.image_tag_mutability)
    error_message = "Debe ser MUTABLE o IMMUTABLE."
  }
}

variable "scan_on_push" {
  description = "Escanear vulnerabilidades automaticamente al subir una imagen."
  type        = bool
  default     = true
}

variable "encryption_type" {
  description = "Tipo de cifrado en reposo: AES256 o KMS."
  type        = string
  default     = "AES256"

  validation {
    condition     = contains(["AES256", "KMS"], var.encryption_type)
    error_message = "Debe ser AES256 o KMS."
  }
}

variable "force_delete" {
  description = "Permitir borrar el repositorio aunque contenga imagenes."
  type        = bool
  default     = false
}

variable "max_image_count" {
  description = "Numero maximo de imagenes a conservar (politica de ciclo de vida)."
  type        = number
  default     = 10
}

variable "tags" {
  description = "Etiquetas comunes aplicadas a los recursos."
  type        = map(string)
  default     = {}
}

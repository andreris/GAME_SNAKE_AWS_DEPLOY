###############################################################################
# Modulo: ecr
# Repositorio de Elastic Container Registry para guardar las distintas
# versiones de la imagen del juego. Incluye politica de ciclo de vida para
# no acumular imagenes viejas indefinidamente.
###############################################################################

# Repositorio ECR donde se publican las imagenes (ej. viborita:1.0.0, :1.1.0).
resource "aws_ecr_repository" "this" {
  name                 = var.repository_name
  image_tag_mutability = var.image_tag_mutability

  # Escaneo de vulnerabilidades automatico al hacer push (buena practica).
  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }

  # Cifrado de las imagenes en reposo.
  encryption_configuration {
    encryption_type = var.encryption_type
  }

  # Permite que Terraform borre el repo aunque tenga imagenes.
  # Util en entornos de curso; ponlo en false en cuentas prod criticas.
  force_delete = var.force_delete

  tags = var.tags
}

# Politica de ciclo de vida: conserva solo las ultimas N imagenes para
# controlar el costo de almacenamiento del registro.
resource "aws_ecr_lifecycle_policy" "this" {
  repository = aws_ecr_repository.this.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Conservar solo las ultimas ${var.max_image_count} imagenes"
        selection = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = var.max_image_count
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}

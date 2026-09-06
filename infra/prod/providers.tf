# Provider de AWS. La region y (opcionalmente) el perfil se toman de variables.
# - En local: define aws_profile para usar tu perfil de AWS (`aws configure --profile ...`).
# - En CI (GitHub Actions con OIDC): deja aws_profile vacio ("") y las credenciales
#   se toman de las variables de entorno (AWS_ACCESS_KEY_ID, etc.).
provider "aws" {
  region = var.aws_region
  # Si aws_profile esta vacio se pasa null -> el provider usa las variables de
  # entorno del runner en vez de buscar un perfil inexistente.
  profile = var.aws_profile != "" ? var.aws_profile : null

  # Etiquetas por defecto aplicadas a TODOS los recursos del provider.
  default_tags {
    tags = {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  }
}

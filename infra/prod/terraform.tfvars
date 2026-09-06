# Configuracion del entorno PROD para el juego "viborita".
# Ajusta estos valores antes de desplegar.

aws_region   = "us-east-1"
aws_profile  = "" # vacio = usa variables de entorno (OIDC en CI). En local pon tu perfil.
project_name = "viborita"
environment  = "prod"

vpc_cidr = "10.10.0.0/16"

public_subnets = [
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

game_subnet_name = "subnet-a-juego"

# Terraform crea el repositorio ECR. Solo eliges que tag desplegar.
# El CI/CD subira la imagen y ECS tomara este tag (ej. latest).
image_tag      = "latest"
container_port = 8000

desired_count = 2
task_cpu      = 256
task_memory   = 512

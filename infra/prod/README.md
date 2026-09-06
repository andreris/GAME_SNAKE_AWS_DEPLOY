# Infraestructura del juego "viborita" (PROD)

Despliega el juego Snake en **AWS ECS Fargate** detras de un **Application Load
Balancer**, dentro de una **VPC** con dos subredes publicas, siguiendo el
diagrama:

```
AWS Account
└── VPC (10.10.0.0/16)
    ├── Subnet A - Juego (10.10.1.0/24)  -> Cluster ECS + tareas del juego
    └── Subnet B - Otro tema (10.10.2.0/24) -> reservada
```

> El ALB necesita al menos 2 AZ, por eso abarca ambas subredes; las **tareas del
> juego corren solo en la Subnet A**.

## Estructura

```
infra/
├── modules/
│   ├── networking/   # VPC, subredes, IGW, rutas
│   └── ecs/          # Cluster, task, service, ALB, SGs, IAM, logs
└── prod/             # Composicion del entorno prod (este directorio)
```

## Requisitos previos

1. Terraform >= 1.5 y AWS CLI configurado con un perfil local.
2. La imagen Docker `viborita:1.0.0` construida (ver `videogame/app/Dockerfile`).
3. Un repositorio ECR con la imagen subida.

### Subir la imagen a ECR (ejemplo us-east-1)

```powershell
$ACCOUNT_ID = (aws sts get-caller-identity --query Account --output text --profile <PERFIL>)
$REGION = "us-east-1"
$REPO = "viborita"

# Crear el repositorio (una sola vez)
aws ecr create-repository --repository-name $REPO --region $REGION --profile <PERFIL>

# Login de Docker contra ECR
aws ecr get-login-password --region $REGION --profile <PERFIL> | docker login --username AWS --password-stdin "$ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com"

# Etiquetar y subir la imagen ya construida localmente
docker tag viborita:1.0.0 "$ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$REPO:1.0.0"
docker push "$ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$REPO:1.0.0"
```

## Desplegar

1. Edita `terraform.tfvars`: pon tu `aws_profile` y el `container_image` real
   (con tu `ACCOUNT_ID`).
2. Ejecuta desde `infra/prod`:

```powershell
terraform init
terraform plan
terraform apply
```

3. Al terminar, abre la URL que aparece en el output `game_url`.

## Limpiar

```powershell
terraform destroy
```

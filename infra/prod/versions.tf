terraform {
  required_version = ">= 1.5"

  # Backend remoto: el state se guarda en S3 (no en disco local).
  # use_lockfile activa el bloqueo nativo de S3 (DynamoDB esta deprecado).
  # encrypt cifra el state en reposo. Versiona el bucket para poder recuperar.
  backend "s3" {
    bucket       = "devops-primer"
    key          = "viborita/prod/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.80"
    }
  }
}

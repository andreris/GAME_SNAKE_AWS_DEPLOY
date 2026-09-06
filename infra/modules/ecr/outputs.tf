output "repository_url" {
  description = "URL del repositorio ECR (usar como destino del docker push y como container_image)."
  value       = aws_ecr_repository.this.repository_url
}

output "repository_arn" {
  description = "ARN del repositorio ECR."
  value       = aws_ecr_repository.this.arn
}

output "repository_name" {
  description = "Nombre del repositorio ECR."
  value       = aws_ecr_repository.this.name
}

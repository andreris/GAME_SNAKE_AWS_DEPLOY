output "vpc_id" {
  description = "ID de la VPC del juego."
  value       = module.networking.vpc_id
}

output "public_subnet_ids" {
  description = "IDs de las subredes publicas (A y B)."
  value       = module.networking.public_subnet_ids
}

output "ecr_repository_url" {
  description = "URL del repositorio ECR (destino del docker push y del CI/CD)."
  value       = module.ecr.repository_url
}

output "ecs_cluster_name" {
  description = "Nombre del cluster ECS."
  value       = module.ecs.cluster_name
}

output "ecs_service_name" {
  description = "Nombre del servicio ECS."
  value       = module.ecs.service_name
}

output "game_url" {
  description = "URL publica para abrir el juego (DNS del ALB)."
  value       = "http://${module.ecs.alb_dns_name}"
}

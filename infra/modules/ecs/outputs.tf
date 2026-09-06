output "cluster_name" {
  description = "Nombre del cluster ECS."
  value       = aws_ecs_cluster.this.name
}

output "cluster_arn" {
  description = "ARN del cluster ECS."
  value       = aws_ecs_cluster.this.arn
}

output "service_name" {
  description = "Nombre del servicio ECS."
  value       = aws_ecs_service.app.name
}

output "task_definition_arn" {
  description = "ARN de la task definition activa."
  value       = aws_ecs_task_definition.app.arn
}

output "alb_dns_name" {
  description = "DNS publico del ALB para abrir el juego en el navegador."
  value       = aws_lb.app.dns_name
}

output "log_group_name" {
  description = "Grupo de logs de CloudWatch del contenedor."
  value       = aws_cloudwatch_log_group.app.name
}

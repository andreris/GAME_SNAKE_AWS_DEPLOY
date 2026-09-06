output "vpc_id" {
  description = "ID de la VPC creada."
  value       = aws_vpc.this.id
}

output "vpc_cidr" {
  description = "CIDR de la VPC."
  value       = aws_vpc.this.cidr_block
}

# Mapa nombre -> id de subred, para referenciar una subred puntual (ej. Subnet A).
output "public_subnet_ids_by_name" {
  description = "IDs de las subredes publicas indexadas por nombre."
  value       = { for name, subnet in aws_subnet.public : name => subnet.id }
}

# Lista de todos los IDs de subredes publicas (necesaria para el ALB multi-AZ).
output "public_subnet_ids" {
  description = "Lista de IDs de todas las subredes publicas."
  value       = [for subnet in aws_subnet.public : subnet.id]
}

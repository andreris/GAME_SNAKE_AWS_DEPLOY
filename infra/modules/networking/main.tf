###############################################################################
# Modulo: networking
# Crea la red base para el juego: VPC, Internet Gateway, subredes publicas
# (Subnet A - Juego, Subnet B - Otro tema) y la tabla de rutas hacia internet.
###############################################################################

locals {
  name_prefix = "${var.project_name}-${var.environment}"
}

# VPC: red privada virtual que contiene toda la infraestructura del juego.
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true # resolucion DNS interna
  enable_dns_hostnames = true # nombres DNS para las instancias/ENIs

  tags = merge(var.tags, {
    Name = "${local.name_prefix}-vpc"
  })
}

# Internet Gateway: puerta de salida/entrada a internet para subredes publicas.
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(var.tags, {
    Name = "${local.name_prefix}-igw"
  })
}

# Subredes publicas. Cada una se define con nombre, CIDR y AZ (Subnet A, B, ...).
# map_public_ip_on_launch = true para que las tareas Fargate obtengan IP publica.
resource "aws_subnet" "public" {
  for_each = { for s in var.public_subnets : s.name => s }

  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = true

  tags = merge(var.tags, {
    Name = "${local.name_prefix}-${each.value.name}"
    Tier = "public"
  })
}

# Tabla de rutas publica: enruta todo el trafico saliente (0.0.0.0/0) al IGW.
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = merge(var.tags, {
    Name = "${local.name_prefix}-public-rt"
  })
}

# Asocia cada subred publica con la tabla de rutas hacia el IGW.
resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

# Create Gateway Endpoints (e.g., S3, DynamoDB)
resource "aws_vpc_endpoint" "gateway" {
  for_each = { for svc in var.gateway_services : svc => svc }

  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.region}.${each.value}"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = var.route_table_ids

  tags = merge(var.tags, {
    Name = "${var.environment}-${each.key}-gateway-endpoint"
  })
}

# Create Interface Endpoints (e.g., SSM, EC2 Messages)
resource "aws_vpc_endpoint" "interface" {
  for_each = { for svc in var.interface_services : svc => svc }

  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.region}.${each.value}"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.private_subnet_ids
  security_group_ids  = [var.security_group_id]
  private_dns_enabled = true

  tags = merge(var.tags, {
    Name = "${var.environment}-${each.key}-interface-endpoint"
  })
}

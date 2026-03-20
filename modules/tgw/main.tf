# Create the Transit Gateway
resource "aws_ec2_transit_gateway" "this" {
  description                   = "${var.name}-${var.environment}-tgw"
  auto_accept_shared_attachments = "enable"

  default_route_table_association = "enable"
  default_route_table_propagation = "enable"

  dns_support       = "enable"
  vpn_ecmp_support  = "enable"

  tags = merge(var.tags, {
    Name = "${var.name}-${var.environment}-tgw"
  })
}

# Create one VPC attachment per entry in the attachments map
resource "aws_ec2_transit_gateway_vpc_attachment" "this" {
  for_each = var.attachments

  vpc_id             = each.value.vpc_id
  subnet_ids         = each.value.subnet_ids
  transit_gateway_id = aws_ec2_transit_gateway.this.id

  tags = merge(var.tags, {
    Name = "${var.environment}-${each.key}-tgw-attachment"
  })
}

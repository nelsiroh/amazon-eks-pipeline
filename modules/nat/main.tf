# Create an Elastic IP for the NAT Gateway (required)
resource "aws_eip" "this" {
  tags = merge(var.tags, {
    Name = "${var.environment}-nat-eip"
  })
}

# Create the NAT Gateway in the first public subnet
resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.this.id
  subnet_id     = var.public_subnet_ids[0] # Always use the first public subnet

  tags = merge(var.tags, {
    Name = "${var.environment}-nat-gateway"
  })

  depends_on = [aws_eip.this]
}

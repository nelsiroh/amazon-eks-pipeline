resource "aws_security_group" "this" {
  name        = "${var.name}-${var.environment}-sg"
  description = var.description
  vpc_id      = var.vpc_id

  # Allow inbound HTTPS (443) from specified source (e.g., VPC CIDR)
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.allowed_cidr_block]
    description = "Allow HTTPS traffic from VPC"
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = merge(var.tags, {
    Name = "${var.name}-${var.environment}-sg"
  })
}

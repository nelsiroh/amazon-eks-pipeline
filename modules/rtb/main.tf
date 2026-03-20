# Public Route Table (for internet-bound public subnet traffic)
resource "aws_route_table" "public" {
  count  = var.create_public_route_table ? 1 : 0
  vpc_id = var.vpc_id

  # Default route to Internet Gateway
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.igw_id
  }

  tags = merge(var.tags, {
    Name = "${var.environment}-public-rt"
  })
}

# Associate each public subnet with the public route table
resource "aws_route_table_association" "public" {
  count          = var.create_public_route_table ? length(var.public_subnet_ids) : 0
  subnet_id      = var.public_subnet_ids[count.index]
  route_table_id = aws_route_table.public[0].id
}

# Private Route Table (for internal + internet-bound private traffic)
resource "aws_route_table" "private" {
  count  = var.create_private_route_table ? 1 : 0
  vpc_id = var.vpc_id

  # Default route for internet-bound traffic via NAT Gateway
  dynamic "route" {
    for_each = var.nat_gateway_id != null ? [1] : []
    content {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = var.nat_gateway_id
    }
  }

  # Add routes for internal VPC-to-VPC communication via Transit Gateway
  dynamic "route" {
    for_each = var.tgw_route_cidrs
    content {
      cidr_block         = route.value
      transit_gateway_id = var.transit_gateway_id
    }
  }

  tags = merge(var.tags, {
    Name = "${var.environment}-private-rt"
  })
}

# Associate each private subnet with the private route table
resource "aws_route_table_association" "private" {
  count          = var.create_private_route_table ? length(var.private_subnet_ids) : 0
  subnet_id      = var.private_subnet_ids[count.index]
  route_table_id = aws_route_table.private[0].id
}

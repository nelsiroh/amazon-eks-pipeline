locals {
  total_subnets = var.num_public_subnets + var.num_private_subnets
}

resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(var.tags, {
    Name    = "${var.environment}-vpc-${var.aws_region}"
    Company = var.company_name
  })
}

# Get AWS Availability Zones dynamically
data "aws_availability_zones" "available" {}

# Enforce total_subnets <= 16 using a Terraform validation check
resource "null_resource" "validate_total_subnets" {
  count = local.total_subnets <= 16 ? 0 : 1

  provisioner "local-exec" {
    command = "echo 'Error: The total number of public and private subnets must not exceed 16. Found: ${local.total_subnets}' && exit 1"
  }
}

# Public Subnets (dynamically generated)
resource "aws_subnet" "public" {
  count = var.num_public_subnets

  vpc_id            = aws_vpc.this.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 4, count.index) # Dynamic CIDR allocation
  availability_zone = data.aws_availability_zones.available.names[count.index % length(data.aws_availability_zones.available.names)]

  tags = merge(var.tags, {
    Name = "${var.environment}-public-subnet-${count.index + 1}"
  })
}

# Private Subnets (dynamically generated)
resource "aws_subnet" "private" {
  count = var.num_private_subnets

  vpc_id            = aws_vpc.this.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 4, var.num_public_subnets + count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index % length(data.aws_availability_zones.available.names)]

  tags = merge(var.tags, {
    Name = "${var.environment}-private-subnet-${count.index + 1}"
  })
}

# Project name (used for dynamic naming)
project_name = "aethernubis-amz-eks-pipeline"

# VPC CIDR Block for this environment
vpc_cidr = "10.3.0.0/16"

# Number of public and private subnets (should match number of AZs)
num_public_subnets  = 2
num_private_subnets = 2

# Enable NAT Gateway for private subnets
enable_nat_gateway = true

# Tags applied to all AWS resources
tags = {
  Project     = "aethernubis-amz-eks-pipeline"
  Environment = "dev"
  ManagedBy   = "Terraform"
  Team        = "AetherNubis LLC"
}

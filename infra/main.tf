# Determine current AWS region
data "aws_region" "current" {}

# Virtual Private Cloud VPC module declaration
module "vpc" {
  source              = "../modules/vpc"
  vpc_cidr            = var.vpc_cidr
  environment         = var.environment
  aws_region          = var.region
  num_public_subnets  = var.num_public_subnets
  num_private_subnets = var.num_private_subnets
  enable_nat_gateway  = var.enable_nat_gateway
  project_name        = var.project_name
  company_name        = var.company_name
  tags                = merge(var.tags, {
    Company = var.company_name
  })
}

# Internet Gateway module declaration
module "igw" {
  source      = "../modules/igw"
  vpc_id      = module.vpc.vpc_id
  environment = var.environment
  tags        = var.tags
}

# Network Address Translation Gateway (NAT Gateway) module declaration
module "nat" {
  source             = "../modules/nat"
  environment        = var.environment
  public_subnet_ids  = module.vpc.public_subnet_ids
  tags               = var.tags
}

# Public Route Table module declaration
module "rtb" {
  source                  = "../modules/rtb"
  vpc_id                  = module.vpc.vpc_id
  igw_id                  = module.igw.igw_id
  public_subnet_ids       = module.vpc.public_subnet_ids
  private_subnet_ids      = module.vpc.private_subnet_ids
  nat_gateway_id          = module.nat.nat_gateway_id
  transit_gateway_id      = null # or add later
  tgw_route_cidrs         = []
  create_public_route_table  = true
  create_private_route_table = true
  environment             = var.environment
  tags                    = var.tags
}

# VPC Endoint Security Group module declaration
module "vpc_endpoint_sg" {
  source             = "../modules/sg"
  name               = "vpce"
  environment        = var.environment
  vpc_id             = module.vpc.vpc_id
  allowed_cidr_block = var.vpc_cidr
  tags               = var.tags
}

# VPC Endpoint module declaration
module "vpce" {
  source              = "../modules/vpce"
  vpc_id              = module.vpc.vpc_id
  region              = var.region
  environment         = var.environment
  private_subnet_ids  = module.vpc.private_subnet_ids
  route_table_ids     = [module.rtb.private_route_table_id]
  security_group_id   = module.vpc_endpoint_sg.security_group_id

  gateway_services    = ["s3"]
  interface_services  = ["ssm", "ec2messages", "ssmmessages"]

  tags                = var.tags
}

# Application Load Balancer (ALB) module declaration
module "alb" {
  source             = "../modules/alb"
  name               = "web"
  environment        = var.environment
  vpc_id             = module.vpc.vpc_id
  subnet_ids         = module.vpc.public_subnet_ids
  security_group_id  = module.alb_sg.security_group_id
  target_port        = 8080
  health_check_path  = "/healthz"
  tags               = var.tags
}

# ALB Security Group module declaration
module "alb_sg" {
  source             = "../modules/sg"
  name               = "alb"
  environment        = var.environment
  vpc_id             = module.vpc.vpc_id
  allowed_cidr_block = "0.0.0.0/0" # Allow from anywhere for public access
  tags               = var.tags
}

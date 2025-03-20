provider "aws" {
  region  = var.region
}

data "aws_region" "current" {}

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

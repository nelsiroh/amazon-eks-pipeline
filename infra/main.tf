locals {
  cluster_name = "${var.project_name}-${var.environment}-${var.region}"

  tags = merge(var.tags, {
    Company = var.company_name
  })
}

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
  tags                = local.tags
}

module "igw" {
  source      = "../modules/igw"
  vpc_id      = module.vpc.vpc_id
  environment = var.environment
  tags        = local.tags
}

module "rtb" {
  source                     = "../modules/rtb"
  vpc_id                     = module.vpc.vpc_id
  igw_id                     = module.igw.igw_id
  public_subnet_ids          = module.vpc.public_subnet_ids
  private_subnet_ids         = []
  create_public_route_table  = true
  create_private_route_table = false
  environment                = var.environment
  tags                       = local.tags
}

module "eks" {
  source                  = "../modules/eks"
  cluster_name            = local.cluster_name
  environment             = var.environment
  vpc_id                  = module.vpc.vpc_id
  subnet_ids              = module.vpc.public_subnet_ids
  kubernetes_version      = var.kubernetes_version
  endpoint_public_access  = true
  endpoint_private_access = false
  tags                    = local.tags
}

module "eks_node_group" {
  source          = "../modules/eks_node_group"
  cluster_name    = module.eks.cluster_name
  subnet_ids      = module.vpc.public_subnet_ids
  node_group_name = "general"
  capacity_type   = "ON_DEMAND"
  instance_types  = var.instance_types
  desired_size    = 1
  min_size        = 0
  max_size        = 3
  disk_size       = 30
  tags            = local.tags
}

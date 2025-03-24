variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "num_public_subnets" {
  description = "Number of public subnets (must be between 2 and 14)"
  type        = number
}

variable "num_private_subnets" {
  description = "Number of private subnets (must be between 2 and 14)"
  type        = number
}

variable "tags" {
  description = "Tags to apply to AWS resources"
  type        = map(string)
}

variable "region" {
  description = "AWS Region"
  type        = string
}

variable "account_id" {
  description = "AWS Account ID"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "company_name" {
  description = "Company name"
  type        = string
}

variable "aws_organization" {
  description = "AWS Organization ID"
  type        = string
}

variable "enable_nat_gateway" {
  description = "Enable NAT Gateway for private subnets"
  type        = bool
}

variable "project_name" {
  description = "Project name for dynamic resource naming"
  type        = string
}

variable "route53_zone_id" {
  type        = string
  description = "The ID of the Route 53 hosted zone used for ACM DNS validation"
}

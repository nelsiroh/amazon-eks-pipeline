variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "aws_region" {
  description = "AWS Region"
  type        = string
}

variable "num_public_subnets" {
  description = "Number of public subnets (must be between 2 and 14)"
  type        = number

  validation {
    condition     = var.num_public_subnets >= 2 && var.num_public_subnets <= 14
    error_message = "The number of public subnets must be between 2 and 14."
  }
}

variable "num_private_subnets" {
  description = "Number of private subnets (must be between 2 and 14)"
  type        = number

  validation {
    condition     = var.num_private_subnets >= 2 && var.num_private_subnets <= 14
    error_message = "The number of private subnets must be between 2 and 14."
  }
}


variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
}

variable "company_name" {
    description = "Name of company"
    type = string
}

variable "enable_nat_gateway" {
  description = "Enable NAT Gateway for private subnets"
  type        = bool
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
}

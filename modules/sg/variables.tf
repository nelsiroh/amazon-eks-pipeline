# Security group name prefix
variable "name" {
  type        = string
  description = "Name prefix for the security group"
}

# Environment label (e.g., dev, prod)
variable "environment" {
  type        = string
  description = "Environment name"
}

# Description for the security group
variable "description" {
  type        = string
  default     = "Security group for interface endpoints"
}

# VPC ID where the security group will be created
variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

# CIDR block allowed to access port 443 (usually the VPC CIDR)
variable "allowed_cidr_block" {
  type        = string
  description = "CIDR block allowed to access port 443"
}

# Tags to apply to the security group
variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to apply"
}

variable "ingress_ports" {
  type        = list(number)
  default     = [443]
  description = "List of ports to allow inbound from allowed_cidr_block"
}

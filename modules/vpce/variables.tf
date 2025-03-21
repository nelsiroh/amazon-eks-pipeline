# VPC context
variable "vpc_id" {
  type        = string
  description = "VPC ID to associate the endpoints with"
}

variable "region" {
  type        = string
  description = "AWS region"
}

variable "environment" {
  type        = string
  description = "Environment name (e.g., dev, prod)"
}

# Endpoint placement
variable "private_subnet_ids" {
  type        = list(string)
  description = "List of private subnet IDs for interface endpoints"
}

variable "route_table_ids" {
  type        = list(string)
  description = "List of route table IDs for gateway endpoint associations"
}

# Security group for interface endpoints
variable "security_group_id" {
  type        = string
  description = "Security group ID to assign to interface endpoints"
}

# Service types
variable "gateway_services" {
  type        = list(string)
  default     = []
  description = "List of Gateway endpoint services (e.g., [\"s3\"])"
}

variable "interface_services" {
  type        = list(string)
  default     = []
  description = "List of Interface endpoint services (e.g., [\"ssm\", \"ec2messages\"])"
}

# Common tags
variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to apply to all endpoint resources"
}

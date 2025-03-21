# Environment label (e.g., dev, prod)
variable "environment" {
  type        = string
  description = "Environment name used for tagging"
}

# List of public subnet IDs (we'll use the first one for the NAT Gateway)
variable "public_subnet_ids" {
  type        = list(string)
  description = "List of public subnet IDs — the NAT Gateway will be placed in the first one"
}

# Tags to apply to the NAT resources
variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to apply to the NAT Gateway and Elastic IP"
}

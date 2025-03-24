variable "vpc_id" {
  type        = string
  description = "The ID of the VPC to attach the Internet Gateway to"
}

variable "environment" {
  type        = string
  description = "Environment name (e.g., dev, prod)"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to apply to the IGW"
}

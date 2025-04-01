# Name prefix for the TGW
variable "name" {
  type        = string
  description = "Name prefix for the Transit Gateway"
}

# Environment label
variable "environment" {
  type        = string
  description = "Deployment environment (e.g., dev, prod)"
}

# Map of VPC attachments: key = label, value = VPC and subnet IDs
variable "attachments" {
  type = map(object({
    vpc_id     = string
    subnet_ids = list(string)
  }))
  default     = {}
  description = "Map of VPC attachments to create"
}

# Tags applied to TGW and its attachments
variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to apply to all TGW resources"
}

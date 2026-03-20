# Name prefix for the ALB and associated resources
variable "name" {
  type        = string
  description = "Base name for the ALB"
}

# Environment context (e.g., dev, prod)
variable "environment" {
  type        = string
  description = "Deployment environment name"
}

# VPC where ALB and target group will be created
variable "vpc_id" {
  type        = string
  description = "VPC ID for the ALB and target group"
}

# Public subnet IDs to place the ALB in
variable "subnet_ids" {
  type        = list(string)
  description = "List of public subnet IDs for ALB placement"
}

# Security group attached to the ALB
variable "security_group_id" {
  type        = string
  description = "Security group ID for the ALB"
}

# Backend application port (used by the target group)
variable "target_port" {
  type        = number
  default     = 80
  description = "Port your backend service is listening on"
}

# Path used by ALB health checks
variable "health_check_path" {
  type        = string
  default     = "/"
  description = "Health check path used by the target group"
}

## ACM certificate for HTTPS (required for HTTPS listener)
# variable "acm_certificate_arn" {
#   type        = string
#   default     = null
#   description = "ACM certificate ARN for HTTPS listener"
# }

# Common tags applied to all resources
variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to apply to ALB, listeners, and target group"
}

# Name prefix for tagging
variable "name" {
  type        = string
  description = "Name prefix for tagging the ACM certificate"
}

# Environment label (e.g., dev, prod)
variable "environment" {
  type        = string
  description = "Deployment environment name"
}

# Primary domain name (e.g., *.aethernubis.com)
variable "domain_name" {
  type        = string
  description = "Primary domain name for the certificate"
}

# Subject Alternative Names (e.g., api.aethernubis.com, www.aethernubis.com)
variable "san_names" {
  type        = list(string)
  default     = []
  description = "Optional SAN names for the certificate"
}

# Hosted Zone ID for aethernubis.com
variable "hosted_zone_id" {
  type = string
  description = "Hosted Zone ID for aethernubis.com"
}

# Common resource tags
variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to apply to ACM certificate and validation records"
}

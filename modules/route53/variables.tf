# Domain name (e.g., aethernubis.com)
variable "domain_name" {
  type        = string
  description = "The domain name to manage (e.g., aethernubis.com)"
}

# DNS records to create under the hosted zone
variable "records" {
  type = map(object({
    type    = string         # A, CNAME, etc.
    ttl     = number         # TTL in seconds
    records = list(string)   # IPs or targets
    alias   = object({       # Optional alias record (for ALBs)
      name                   = string
      zone_id                = string
      evaluate_target_health = bool
    })
  }))
  default     = {}
  description = "Map of record names to record configuration"
}

# Tags to apply
variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags for hosted zone and records"
}

variable "name" {
  description = "Name of the IAM role."
  type        = string
}

variable "description" {
  description = "Description of the IAM role."
  type        = string
  default     = null
}

variable "assume_role_policy_json" {
  description = "JSON trust policy document for the IAM role."
  type        = string
}

variable "path" {
  description = "Path for the IAM role."
  type        = string
  default     = "/"
}

variable "max_session_duration" {
  description = "Maximum session duration in seconds."
  type        = number
  default     = 3600
}

variable "permissions_boundary" {
  description = "ARN of the permissions boundary policy to attach to the role."
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to apply to the IAM role."
  type        = map(string)
  default     = {}
}

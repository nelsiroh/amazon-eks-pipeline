variable "name" {
  description = "Name of the IAM policy."
  type        = string
}

variable "description" {
  description = "Description of the IAM policy."
  type        = string
  default     = null
}

variable "policy_json" {
  description = "JSON policy document for the IAM policy."
  type        = string
}

variable "path" {
  description = "Path for the IAM policy."
  type        = string
  default     = "/"
}

variable "tags" {
  description = "Tags to apply to the IAM policy."
  type        = map(string)
  default     = {}
}

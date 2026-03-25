variable "cluster_name" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "node_group_name" {
  type = string
}

variable "capacity_type" {
  type    = string
  default = "ON_DEMAND"
}

variable "instance_types" {
  type = list(string)
}

variable "disk_size" {
  type    = number
  default = 30
}

variable "desired_size" {
  type = number
}

variable "min_size" {
  type = number
}

variable "max_size" {
  type = number
}

variable "ami_type" {
  type    = string
  default = "AL2023_x86_64_STANDARD"
}

variable "max_unavailable" {
  type    = number
  default = 1
}

variable "labels" {
  type    = map(string)
  default = {}
}

variable "tags" {
  type = map(string)
}

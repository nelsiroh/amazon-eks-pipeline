# Core VPC ID
variable "vpc_id" {
  type        = string
  description = "The ID of the VPC for which the route tables will be created"
}

# Environment label (e.g., dev, prod)
variable "environment" {
  type        = string
  description = "Environment name used for tagging resources"
}

# Common tags applied to all route table resources
variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to apply to the route tables and associations"
}

# --- Public Routing ---

# Toggle to create a public route table
variable "create_public_route_table" {
  type        = bool
  default     = true
  description = "Whether to create the public route table"
}

# Internet Gateway ID for public routing (used for default route)
variable "igw_id" {
  type        = string
  default     = null
  description = "Internet Gateway ID to use as target for public route table"
}

# List of public subnet IDs to associate with the public route table
variable "public_subnet_ids" {
  type        = list(string)
  default     = []
  description = "List of public subnet IDs to associate with the public route table"
}

# --- Private Routing ---

# Toggle to create a private route table
variable "create_private_route_table" {
  type        = bool
  default     = true
  description = "Whether to create the private route table"
}

# List of private subnet IDs to associate with the private route table
variable "private_subnet_ids" {
  type        = list(string)
  default     = []
  description = "List of private subnet IDs to associate with the private route table"
}

# NAT Gateway ID used for internet-bound traffic from private subnets
variable "nat_gateway_id" {
  type        = string
  default     = null
  description = "NAT Gateway ID to use for the 0.0.0.0/0 route in private route table"
}

# Transit Gateway ID used for internal routing between VPCs
variable "transit_gateway_id" {
  type        = string
  default     = null
  description = "Transit Gateway ID to route internal CIDRs through"
}

# List of CIDRs to route via the Transit Gateway
variable "tgw_route_cidrs" {
  type        = list(string)
  default     = []
  description = "List of CIDR blocks to route through the Transit Gateway"
}

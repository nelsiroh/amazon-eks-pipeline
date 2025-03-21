# List of created gateway endpoint IDs
output "gateway_endpoint_ids" {
  value       = values(aws_vpc_endpoint.gateway)[*].id
  description = "IDs of the created gateway VPC endpoints"
}

# List of created interface endpoint IDs
output "interface_endpoint_ids" {
  value       = values(aws_vpc_endpoint.interface)[*].id
  description = "IDs of the created interface VPC endpoints"
}

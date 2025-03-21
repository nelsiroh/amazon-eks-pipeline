# Output for the public route table ID (null if not created)
output "public_route_table_id" {
  value       = try(aws_route_table.public[0].id, null)
  description = "The ID of the public route table"
}

# Output for the private route table ID (null if not created)
output "private_route_table_id" {
  value       = try(aws_route_table.private[0].id, null)
  description = "The ID of the private route table"
}

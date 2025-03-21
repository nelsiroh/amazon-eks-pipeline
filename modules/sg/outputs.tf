# Output the SG ID for use in other modules
output "security_group_id" {
  value       = aws_security_group.this.id
  description = "The ID of the created security group"
}

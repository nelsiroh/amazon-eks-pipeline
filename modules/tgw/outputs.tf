# Output the TGW ID
output "transit_gateway_id" {
  value       = aws_ec2_transit_gateway.this.id
  description = "Transit Gateway ID"
}

# Output map of VPC attachment IDs
output "attachment_ids" {
  value = {
    for k, v in aws_ec2_transit_gateway_vpc_attachment.this : k => v.id
  }
  description = "Map of VPC attachment IDs by key"
}

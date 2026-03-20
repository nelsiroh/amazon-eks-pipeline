output "hosted_zone_id" {
  value       = data.aws_route53_zone.this.zone_id
  description = "ID of the Route 53 hosted zone"
}

output "domain_name" {
  value       = data.aws_route53_zone.this.name
  description = "The root domain name"
}

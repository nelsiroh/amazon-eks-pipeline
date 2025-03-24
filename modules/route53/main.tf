# Lookup an existing public hosted zone for your domain
data "aws_route53_zone" "this" {
  name         = var.domain_name
  private_zone = false
}

# Create DNS records (A, CNAME, ALIAS, etc.)
resource "aws_route53_record" "records" {
  for_each = var.records

  zone_id = data.aws_route53_zone.this.zone_id
  name    = each.key
  type    = each.value.type

  # Non-alias records: define ttl and records
  ttl     = each.value.alias == null ? each.value.ttl : null
  records = each.value.alias == null ? each.value.records : null

  # Alias record (for ALB, CloudFront, etc.)
  dynamic "alias" {
    for_each = each.value.alias != null ? [1] : []
    content {
      name                   = each.value.alias.name
      zone_id                = each.value.alias.zone_id
      evaluate_target_health = each.value.alias.evaluate_target_health
    }
  }
}


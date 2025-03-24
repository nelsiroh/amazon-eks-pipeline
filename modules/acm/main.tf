# Create ACM certificate with DNS validation
resource "aws_acm_certificate" "this" {
  domain_name       = var.domain_name                      # e.g., *.aethernubis.com
  validation_method = "DNS"

  subject_alternative_names = var.san_names                # Optional SANs

  tags = merge(var.tags, {
    Name = "${var.name}-${var.environment}-acm"
  })
}

# Create DNS validation record for each domain
resource "aws_route53_record" "validation" {
  for_each = {
    for dvo in aws_acm_certificate.this.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }

  zone_id = var.hosted_zone_id                             # Your Route 53 public hosted zone
  name    = each.value.name
  type    = each.value.type
  ttl     = 60
  records = [each.value.record]
}

# Wait until certificate is validated
resource "aws_acm_certificate_validation" "this" {
  certificate_arn         = aws_acm_certificate.this.arn
  validation_record_fqdns = [for r in aws_route53_record.validation : r.fqdn]
}

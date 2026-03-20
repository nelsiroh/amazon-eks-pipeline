# DNS name of the ALB (used for routing traffic)
output "alb_dns_name" {
  value       = aws_lb.this.dns_name
  description = "The DNS name of the Application Load Balancer"
}

# Target group ARN (for ECS/EKS/EC2 registration)
output "target_group_arn" {
  value       = aws_lb_target_group.this.arn
  description = "The ARN of the target group associated with the ALB"
}

# Hosted zone ID for use in Route 53 alias records
output "lb_zone_id" {
  value       = aws_lb.this.zone_id
  description = "The Route 53 hosted zone ID of the ALB"
}

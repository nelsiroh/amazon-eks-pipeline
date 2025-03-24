# DNS name to access the ALB publicly
output "alb_dns_name" {
  value       = aws_lb.this.dns_name
  description = "DNS name of the ALB"
}

# Target group ARN (can be used by ECS/EKS/EC2 to register targets)
output "target_group_arn" {
  value       = aws_lb_target_group.this.arn
  description = "ARN of the ALB target group"
}

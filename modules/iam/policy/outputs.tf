output "id" {
  description = "ID of the IAM policy."
  value       = aws_iam_policy.this.id
}

output "name" {
  description = "Name of the IAM policy."
  value       = aws_iam_policy.this.name
}

output "arn" {
  description = "ARN of the IAM policy."
  value       = aws_iam_policy.this.arn
}

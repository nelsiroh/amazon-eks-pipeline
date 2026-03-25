output "id" {
  description = "ID of the IAM role."
  value       = aws_iam_role.this.id
}

output "name" {
  description = "Name of the IAM role."
  value       = aws_iam_role.this.name
}

output "arn" {
  description = "ARN of the IAM role."
  value       = aws_iam_role.this.arn
}

output "unique_id" {
  description = "Stable and unique string identifying the IAM role."
  value       = aws_iam_role.this.unique_id
}

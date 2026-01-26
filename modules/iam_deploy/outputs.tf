output "policy_arn" {
  description = "ARN da policy de deploy"
  value       = var.create_policy ? aws_iam_policy.deploy[0].arn : null
}

output "policy_name" {
  description = "Nome da policy de deploy"
  value       = var.create_policy ? aws_iam_policy.deploy[0].name : null
}

output "app_name" {
  description = "Nome da aplicação CodeDeploy"
  value       = local.codedeploy_app
}

output "app_arn" {
  description = "ARN da aplicação CodeDeploy"
  value       = var.create_codedeploy_app ? aws_codedeploy_app.this[0].arn : null
}

output "deployment_group_name" {
  description = "Nome do deployment group"
  value       = aws_codedeploy_deployment_group.this.deployment_group_name
}

output "deployment_group_arn" {
  description = "ARN do deployment group"
  value       = aws_codedeploy_deployment_group.this.arn
}

output "role_arn" {
  description = "ARN da role do CodeDeploy"
  value       = local.iam_role_arn
}

output "role_name" {
  description = "Nome da role do CodeDeploy"
  value       = var.create_iam_role ? aws_iam_role.codedeploy[0].name : null
}

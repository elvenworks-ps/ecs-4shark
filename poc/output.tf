output "codedeploy_app_name" {
  description = "Nome da aplicação CodeDeploy"
  value       = module.codedeploy_web.app_name
}

output "codedeploy_deployment_group" {
  description = "Nome do deployment group CodeDeploy"
  value       = module.codedeploy_web.deployment_group_name
}

output "codedeploy_role_arn" {
  description = "ARN da role do CodeDeploy"
  value       = module.codedeploy_web.role_arn
}

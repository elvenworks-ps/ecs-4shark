output "ecs_cluster_name" {
  description = "Nome do cluster ECS"
  value       = aws_ecs_cluster.cluster.name
}

output "security_group_id" {
  description = "ID do grupo de segurança ECS"
  value       = aws_security_group.ecs_sg.id
}

output "launch_template_id" {
  description = "ID do Launch Template"
  value       = aws_launch_template.this.id
}

output "autoscaling_group_id" {
  description = "ID do Auto Scaling Group"
  value       = aws_autoscaling_group.this.id
}

output "security_group_id" {
  description = "ID do Security Group criado (se aplicável)"
  value       = var.create_security_group ? aws_security_group.this[0].id : null
}

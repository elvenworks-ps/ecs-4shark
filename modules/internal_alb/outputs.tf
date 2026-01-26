output "alb_dns_name" {
  description = "DNS name do ALB."
  value       = aws_lb.this.dns_name
}

output "alb_arn" {
  description = "ARN do ALB."
  value       = aws_lb.this.arn
}

output "target_group_arn" {
  description = "ARN do target group."
  value       = aws_lb_target_group.this.arn
}

output "alternate_target_group_arn" {
  description = "ARN do target group alternativo (blue/green)."
  value       = try(aws_lb_target_group.alternate[0].arn, null)
}

output "blue_green_role_arn" {
  description = "IAM role usada pelo ECS para gerenciar ALB em blue/green."
  value       = try(aws_iam_role.ecs_bluegreen[0].arn, null)
}

output "target_group_name" {
  description = "Nome do target group."
  value       = aws_lb_target_group.this.name
}

output "alternate_target_group_name" {
  description = "Nome do target group alternativo (blue/green)."
  value       = try(aws_lb_target_group.alternate[0].name, null)
}

output "listener_arn" {
  description = "ARN do listener HTTP."
  value       = aws_lb_listener.http.arn
}

output "listener_rule_arns_by_priority" {
  description = "Mapa priority -> listener rule ARN (vazio quando blue/green habilitado)."
  value       = { for priority, rule in aws_lb_listener_rule.paths : priority => rule.arn }
}

output "production_listener_rule_arn" {
  description = "ARN da regra de produção (null quando blue/green habilitado)."
  value       = try(aws_lb_listener_rule.paths[var.production_listener_rule_priority].arn, null)
}

output "record_fqdn" {
  description = "FQDN criado no Route53."
  value       = aws_route53_record.alb_cname.fqdn
}

output "security_group_ids" {
  description = "Security groups associados ao ALB."
  value       = local.alb_security_group_ids
}

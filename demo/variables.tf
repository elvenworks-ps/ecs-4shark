variable "name" {}
variable "vpc_name" {}
variable "cidr_block" {}
variable "instance_tenancy" {}
variable "environment" {}
variable "public_subnets" {}
variable "private_subnets" {}
variable "igwname" {}
variable "natname" {}
variable "rtname" {}

## ecs
variable "key_name" {}
variable "cluster_name" {}
variable "instance_type" {}
variable "desired_capacity" {}
variable "max_size" {}
variable "min_size" {}
variable "volume_size" {}
variable "volume_type" {}
variable "associate_public_ip_address" {}
variable "role_name" {}
variable "sgname" {}
variable "ecs_instance_profile" {}
variable "asg_tag" {}
variable "launch_template_name" {}
variable "capacity_provider_name" {}
variable "enable_managed_termination" {}
variable "target_capacity_percent" {}
variable "min_step" {}
variable "max_step" {}
variable "default_weight" {}
variable "default_base" {}

## alb interno
variable "private_zone_name" {
  description = "Nome da private hosted zone no Route53 (ex.: 4shark.internal)"
  type        = string
}

variable "alb_name_prefix" {
  description = "Prefixo para nomear ALB/TG (ex.: beta-app)"
  type        = string
}

variable "alb_record_name" {
  description = "FQDN para o CNAME do ALB (ex.: beta.4shark.internal)"
  type        = string
}

variable "alb_ingress_cidrs" {
  description = "CIDRs permitidos no SG do ALB (porta 80)"
  type        = list(string)
}

variable "service_with_alb" {
  description = "Nome do serviço ECS (chave do mapa) que deve registrar no ALB."
  type        = string
}

variable "enable_blue_green" {
  description = "Habilita recursos de blue/green no ALB e serviço."
  type        = bool
  default     = false
}

variable "production_listener_rule_priority" {
  description = "Prioridade da regra de listener usada como produção (deve existir em listener_rules do ALB)."
  type        = number
  default     = 100
}

variable "blue_green_test_path" {
  description = "Path para listener rule de teste do blue/green."
  type        = string
  default     = "/bg-test*"
}

variable "blue_green_test_priority" {
  description = "Prioridade da listener rule de teste do blue/green."
  type        = number
  default     = 50
}

variable "ecs_service_bluegreen_role_arn" {
  description = "IAM role para o ECS gerenciar target groups em blue/green (ex.: AWSServiceRoleForECS)."
  type        = string
  default     = null
}

variable "services" {
  description = "Mapa de serviços ECS (EC2) a serem criados"
  type        = any
  default     = {}
}

variable "ecr_repositories" {
  type = set(string)
}

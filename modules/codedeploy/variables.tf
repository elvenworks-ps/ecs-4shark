variable "environment" {
  description = "Nome do ambiente (poc, beta, demo, etc.)"
  type        = string
}

variable "app_name" {
  description = "Nome da aplicação (ex: web)"
  type        = string
}

variable "cluster_name" {
  description = "Nome do cluster ECS"
  type        = string
}

variable "service_name" {
  description = "Nome do serviço ECS"
  type        = string
}

variable "listener_arn" {
  description = "ARN do listener do ALB"
  type        = string
}

variable "prod_listener_arn" {
  description = "ARN do listener OU listener rule de produção (usar rule em cenários path-based)."
  type        = string
  default     = null
}

variable "test_listener_arn" {
  description = "ARN do listener OU listener rule de teste (blue/green)."
  type        = string
  default     = null
}

variable "target_group_name" {
  description = "Nome do target group principal (Blue)"
  type        = string
}

variable "alternate_target_group_name" {
  description = "Nome do target group alternativo (Green)"
  type        = string
}

variable "deployment_config_name" {
  description = "Nome da configuração de deployment (CodeDeployDefault.ECSAllAtOnce, ECSLinear10PercentEvery1Minutes, etc.)"
  type        = string
  default     = "CodeDeployDefault.ECSAllAtOnce"
}

variable "action_on_timeout" {
  description = "Ação quando o tempo de espera expira (CONTINUE_DEPLOYMENT ou STOP_DEPLOYMENT)"
  type        = string
  default     = "CONTINUE_DEPLOYMENT"
}

variable "wait_time_in_minutes" {
  description = "Tempo de espera (em minutos) antes de continuar o deployment"
  type        = number
  default     = 0
}

variable "termination_wait_time_in_minutes" {
  description = "Tempo de espera (em minutos) antes de terminar as tasks antigas após deployment bem-sucedido"
  type        = number
  default     = 5
}

variable "tags" {
  description = "Tags a aplicar nos recursos"
  type        = map(string)
  default     = {}
}

variable "create_iam_role" {
  description = "Se deve criar a IAM Role do CodeDeploy (false se já existir)"
  type        = bool
  default     = true
}

variable "create_codedeploy_app" {
  description = "Se deve criar a aplicação CodeDeploy (false se já existir)"
  type        = bool
  default     = true
}

variable "existing_iam_role_arn" {
  description = "ARN da IAM Role existente (quando create_iam_role = false)"
  type        = string
  default     = null
}

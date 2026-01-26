variable "name_prefix" {
  description = "Prefixo base para nomear ALB, target group e listener."
  type        = string
}

variable "vpc_id" {
  description = "ID da VPC onde o ALB será criado."
  type        = string
}

variable "subnet_ids" {
  description = "Subnets privadas onde o ALB interno ficará."
  type        = list(string)
}

variable "security_group_ids" {
  description = "Security groups a anexar ao ALB. Se nulo, o módulo cria um SG próprio."
  type        = list(string)
  default     = null

  validation {
    condition     = var.security_group_ids == null ? true : length(var.security_group_ids) > 0
    error_message = "security_group_ids deve ser uma lista não vazia ou nulo."
  }
}

variable "create_alb_security_group" {
  description = "Define se o módulo cria um security group padrão para o ALB."
  type        = bool
  default     = true

  validation {
    condition     = var.create_alb_security_group ? true : (var.security_group_ids != null && length(var.security_group_ids) > 0)
    error_message = "Defina security_group_ids quando create_alb_security_group for false."
  }
}

variable "alb_ingress_cidrs" {
  description = "CIDRs permitidos no SG do ALB (porta 80). Obrigatório se create_alb_security_group=true."
  type        = list(string)
  default     = []

  validation {
    condition     = (!var.create_alb_security_group) || (length(var.alb_ingress_cidrs) > 0)
    error_message = "Defina alb_ingress_cidrs quando create_alb_security_group for true."
  }
}

variable "target_port" {
  description = "Porta alvo do target group (container expõe HTTP nessa porta)."
  type        = number
  default     = 3000
}

variable "health_check_path" {
  description = "Path usado no health check."
  type        = string
  default     = "/"
}

variable "health_check_matcher" {
  description = "Códigos de retorno aceitáveis para o health check."
  type        = string
  default     = "200-399"
}

variable "health_check_interval" {
  description = "Intervalo do health check (segundos)."
  type        = number
  default     = 30
}

variable "health_check_timeout" {
  description = "Timeout do health check (segundos)."
  type        = number
  default     = 5
}

variable "health_check_healthy_threshold" {
  description = "Número de checks bem-sucedidos para marcar como healthy."
  type        = number
  default     = 5
}

variable "health_check_unhealthy_threshold" {
  description = "Número de falhas para marcar como unhealthy."
  type        = number
  default     = 2
}

variable "listener_rules" {
  description = "Lista de regras path-based no listener HTTP."
  type = list(object({
    priority = number
    path     = string
  }))
  default = [
    { priority = 10, path = "/health" },
    { priority = 100, path = "/" }
  ]
}

variable "record_name" {
  description = "Nome do record CNAME (ex.: beta.4shark.internal)."
  type        = string
}

variable "private_zone_id" {
  description = "Hosted Zone ID privada do Route53."
  type        = string
}

variable "tags" {
  description = "Tags aplicadas a todos os recursos."
  type        = map(string)
  default     = {}
}

variable "enable_blue_green" {
  description = "Cria recursos adicionais para blue/green (target group alternativo e listener de teste)."
  type        = bool
  default     = false
}

variable "production_listener_rule_priority" {
  description = "Prioridade da regra de listener usada como produção (deve existir em listener_rules)."
  type        = number
  default     = 100
}

variable "blue_green_test_path" {
  description = "Path pattern para a regra de teste do blue/green."
  type        = string
  default     = "/bg-test*"
}

variable "blue_green_test_priority" {
  description = "Prioridade da regra de teste do blue/green."
  type        = number
  default     = 50
}

variable "deregistration_delay" {
  description = "Tempo (segundos) que o ALB espera antes de remover um target do target group. Menor = rollbacks mais rápidos."
  type        = number
  default     = 30
}

variable "slow_start" {
  description = "Tempo (segundos) para ramp-up gradual de tráfego em novos targets. 0 = desabilitado."
  type        = number
  default     = 0
}

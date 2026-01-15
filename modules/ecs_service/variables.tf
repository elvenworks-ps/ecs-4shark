variable "cluster_name" {
  description = "Existing ECS cluster name"
  type        = string
}

variable "capacity_provider" {
  description = "Capacity provider name to use on the service"
  type        = string
}

variable "capacity_provider_weight" {
  description = "Weight for capacity provider strategy"
  type        = number
  default     = 1
}

variable "capacity_provider_base" {
  description = "Base for capacity provider strategy"
  type        = number
  default     = 0
}

variable "service_name" {
  description = "Service name"
  type        = string
}

variable "task_family" {
  description = "Task definition family"
  type        = string
}

variable "image" {
  description = "Container image"
  type        = string
}

variable "cpu" {
  description = "Task CPU units"
  type        = number
}

variable "memory" {
  description = "Task memory (MiB)"
  type        = number
}

variable "container_cpu" {
  description = "Container CPU units"
  type        = number
  default     = null
}

variable "container_memory" {
  description = "Container hard memory limit"
  type        = number
  default     = null
}

variable "container_memory_reservation" {
  description = "Container soft memory reservation"
  type        = number
  default     = null
}

variable "container_name" {
  description = "Container name"
  type        = string
}

variable "container_port" {
  description = "Container/listener port"
  type        = number
  default     = null
}

variable "desired_count" {
  description = "Service desired count"
  type        = number
}

variable "subnets" {
  description = "Subnets for awsvpc network configuration"
  type        = list(string)
}

variable "security_groups" {
  description = "Security groups for awsvpc network configuration"
  type        = list(string)
}

variable "assign_public_ip" {
  description = "Assign public IP to tasks"
  type        = bool
  default     = false
}

variable "environment_variables" {
  description = "Plain environment variables"
  type        = map(string)
  default     = {}
}

variable "secrets" {
  description = "Secrets for the container"
  type = list(object({
    name      = string
    valueFrom = string
  }))
  default = []
}

variable "health_check" {
  description = "Container health check block"
  type        = any
  default     = null
}

variable "command" {
  description = "Container command"
  type        = list(string)
  default     = []
}

variable "entrypoint" {
  description = "Container entrypoint"
  type        = list(string)
  default     = []
}

variable "volumes" {
  description = "Task volumes"
  type = list(object({
    name      = string
    host_path = optional(string)
  }))
  default = []
}

variable "execution_role_arn" {
  description = "Execution role ARN"
  type        = string
  default     = null
}

variable "task_role_arn" {
  description = "Task role ARN"
  type        = string
  default     = null
}

variable "load_balancers" {
  description = "Optional load balancer attachments"
  type = list(object({
    target_group_arn = string
    container_name   = string
    container_port   = number
  }))
  default = []
}

variable "deployment_minimum_healthy_percent" {
  description = "Deployment min healthy percent"
  type        = number
  default     = 50
}

variable "deployment_maximum_percent" {
  description = "Deployment max percent"
  type        = number
  default     = 200
}

variable "deployment_controller_type" {
  description = "Deployment controller type (ex.: ECS, CODE_DEPLOY). Null mantém padrão ECS."
  type        = string
  default     = null
}

variable "enable_deployment_circuit_breaker" {
  description = "Habilita deployment circuit breaker."
  type        = bool
  default     = false
}

variable "deployment_rollback" {
  description = "Habilita rollback automático quando circuit breaker está ativo."
  type        = bool
  default     = true
}

variable "advanced_configuration" {
  description = "Advanced configuration for deployment strategies (e.g., blue/green ALB wiring)."
  type        = any
  default     = null
}

variable "enable_execute_command" {
  description = "Enable ECS Exec"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}

variable "enable_cloudwatch_logging" {
  description = "Toggle log driver"
  type        = bool
  default     = true
}

variable "create_cloudwatch_log_group" {
  description = "Create log group"
  type        = bool
  default     = true
}

variable "cloudwatch_log_group_name" {
  description = "Custom log group name"
  type        = string
  default     = null
}

variable "cloudwatch_log_group_use_name_prefix" {
  description = "Use prefix for log group"
  type        = bool
  default     = false
}

variable "cloudwatch_log_group_retention_in_days" {
  description = "Log retention days"
  type        = number
  default     = 30
}

variable "cloudwatch_log_group_kms_key_id" {
  description = "KMS key for log group"
  type        = string
  default     = null
}

variable "deployment_strategy" {
  description = "Deployment strategy: ROLLING, BLUE_GREEN, LINEAR, or CANARY"
  type        = string
  default     = null
}

variable "bake_time_in_minutes" {
  description = "Bake time in minutes for BLUE_GREEN, LINEAR, or CANARY deployments"
  type        = number
  default     = null
}

variable "environment" {
  type = string
}

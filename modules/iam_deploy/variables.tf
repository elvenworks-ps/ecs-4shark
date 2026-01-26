variable "environment" {
  description = "Nome do ambiente (poc, beta, demo, etc.)"
  type        = string
}

variable "policy_name_prefix" {
  description = "Prefixo para o nome da policy (ex: app-staging)"
  type        = string
  default     = "app-staging"
}

variable "cluster_name" {
  description = "Nome do cluster ECS"
  type        = string
}

variable "ecr_repository_arns" {
  description = "Lista de ARNs dos repositórios ECR"
  type        = list(string)
  default     = []
}

variable "task_execution_role_arns" {
  description = "Lista de ARNs das roles de execução de tasks"
  type        = list(string)
  default     = []
}

variable "enable_codedeploy" {
  description = "Habilitar permissões para CodeDeploy"
  type        = bool
  default     = false
}

variable "codedeploy_app_name" {
  description = "Nome da aplicação CodeDeploy (obrigatório se enable_codedeploy = true)"
  type        = string
  default     = ""
}

variable "codedeploy_deployment_group_name" {
  description = "Nome do deployment group CodeDeploy (obrigatório se enable_codedeploy = true)"
  type        = string
  default     = ""
}

variable "iam_user_name" {
  description = "Nome do usuário IAM para anexar a policy (opcional)"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags a aplicar nos recursos"
  type        = map(string)
  default     = {}
}

variable "create_policy" {
  description = "Se deve criar a IAM Policy (false se já existir)"
  type        = bool
  default     = true
}

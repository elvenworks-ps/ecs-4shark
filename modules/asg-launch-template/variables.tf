variable "name" {
  description = "Prefixo do nome do Launch Template e ASG"
  type        = string
}

variable "ami" {
  description = "AMI ID para instâncias"
  type        = string
}

variable "instance_type" {
  description = "Tipo da instância"
  type        = string
}

variable "key_name" {
  description = "Nome do key pair para acesso SSH"
  type        = string
}

variable "subnet_ids" {
  description = "Lista de subnets onde o ASG irá distribuir instâncias (multi-AZ)"
  type        = list(string)
}

variable "security_groups" {
  description = "Lista de Security Groups existentes (se create_security_group = false)"
  type        = list(string)
  default     = []
}

variable "create_security_group" {
  description = "Se true, cria um Security Group gerenciado pelo módulo"
  type        = bool
  default     = false
}

variable "vpc_id" {
  description = "VPC usada se for criado um novo Security Group"
  type        = string
  default     = null
}

variable "sg_ingress_rules" {
  description = "Regras de ingress se criar SG"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = []
}

variable "sg_egress_rules" {
  description = "Regras de egress se criar SG"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

variable "user_data" {
  description = "Script de inicialização (user data)"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags aplicadas ao recurso"
  type        = map(string)
  default     = {}
}

variable "min_size" {
  description = "Número mínimo de instâncias no ASG"
  type        = number
}

variable "max_size" {
  description = "Número máximo de instâncias no ASG"
  type        = number
}

variable "desired_capacity" {
  description = "Número desejado de instâncias no ASG"
  type        = number
}

variable "target_group_arns" {
  description = "Lista de Target Groups (para ALB/NLB). Se vazio, não associa LB."
  type        = list(string)
  default     = []
}

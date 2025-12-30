variable "vpc_id" {
  description = "ID da VPC"
  type        = string
}

variable "subnets" {
  description = "Subredes para rodar as instâncias"
  type        = list(string)
}

variable "cluster_name" {
  description = "Nome do cluster ECS"
  type        = string
}

variable "role_name" {
  description = "Nome da role ECS"
  type        = string
}

variable "instance_type" {
  description = "Tipo da instância EC2"
  type        = string
  default     = "t3a.medium"
}

variable "ami_id" {
  description = "ID da AMI para a instância"
  type        = string
}

variable "desired_capacity" {
  description = "Capacidade desejada do Auto Scaling Group"
  type        = number
  default     = 0
}

variable "max_size" {
  description = "Capacidade maxima do Auto Scaling Group"
  type        = number
  default     = 0
}

variable "min_size" {
  description = "Capacidade minima do Auto Scaling Group"
  type        = number
  default     = 0
}

variable "volume_size" {
  description = "Tamanho do volume em GB"
  type        = number
  default     = 30
}

variable "volume_type" {
  description = "Tipo do volume"
  type        = string
  default     = "gp3"
}

variable "environment" {
  description = "Env tags"
  type        = string
  default     = null
}

variable "key_name" {
  description = "Key name of the Key Pair to use for the instance; which can be managed using the `aws_key_pair` resource"
  type        = string
  default     = "key-pem"
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default = {
    Terraform = "true"
  }
}

variable "associate_public_ip_address" {
  description = "Whether to associate a public IP address"
  type        = bool
  default     = false
}

variable "additional_rules_security_group" {
  description = "Rules security group"
  type        = any
  default     = {}
}

variable "sgname" {
  type    = string
  default = ""
}

variable "ecs_instance_profile" {
  type    = string
  default = ""
}

variable "asg_tag" {
  type    = string
  default = ""
}

variable "launch_template_name" {
  type    = string
  default = ""
}

variable "capacity_provider_name" {
  type        = string
  description = "Provedor de capacidade pras instâncias"
  default     = ""
}

variable "enable_managed_termination" {
  type    = bool
  default = true
}

variable "target_capacity_percent" {
  type    = number
  default = 100
}

variable "min_step" {
  type    = number
  default = 1
}

variable "max_step" {
  type    = number
  default = 100
}

variable "default_weight" {
  type    = number
  default = 100
}

variable "default_base" {
  type    = number
  default = 0
}

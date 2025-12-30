variable "vpc_name" {
  type        = string
  description = "Nome da VPC existente (tag Name)"
}

variable "private_subnets" {
  type        = list(string)
  description = "Blocos CIDR das subnets privadas existentes"
  default     = []
}

variable "public_subnets" {
  type        = list(string)
  description = "Blocos CIDR das subnets públicas existentes"
  default     = []
}

# Alternativa, se preferir buscar por ID
# variable "vpc_id" {
#   type        = string
#   description = "ID da VPC existente"
# }

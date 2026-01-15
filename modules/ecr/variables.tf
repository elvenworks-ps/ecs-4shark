variable "name" {
  description = "Nome do repositório ECR"
  type        = string
}

variable "tags" {
  description = "Tags opcionais"
  type        = map(string)
  default     = {}
}

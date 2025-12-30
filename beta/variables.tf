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

variable "services" {
  description = "Mapa de serviços ECS (EC2) a serem criados"
  type        = map(any)
  default     = {}
}

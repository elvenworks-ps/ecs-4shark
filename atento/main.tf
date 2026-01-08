locals {
  environment = var.environment
  tags = {
    Environment = var.environment
  }
}

data "aws_ami" "ecs_optimized" {
  filter {
    name   = "name"
    values = ["al2023-ami-ecs-hvm-*-x86_64"]
  }

  most_recent = true
  owners      = ["amazon"]
}

# VPC
 module "vpc" {
   source = "../modules/vpc"
   name                    = var.name
   cidr_block              = var.cidr_block
   instance_tenancy        = var.instance_tenancy
   enable_dns_support      = true
   enable_dns_hostnames    = true
   tags                    = local.tags
   environment             = local.environment
   private_subnets         = var.private_subnets
   public_subnets          = var.public_subnets
   map_public_ip_on_launch = true
   igwname                 = var.igwname
   natname                 = var.natname
   rtname                  = var.rtname
   # route_table_routes_private = {
   #   ## add block to create route in subnet-public
   #   "vpc_peering" = {
   #     "cidr_block"                = "10.10.0.0/16"
   #     "vpc_peering_connection_id" = "pcx-xxxxxxxxxxxxxxxxx"
   #   }
   # }
   # route_table_routes_public = {
   #   ## add block to create route in subnet-private
   #   "vpc_peering" = {
   #     "cidr_block"                = "10.10.0.0/16"
   #     "vpc_peering_connection_id" = "pcx-xxxxxxxxxxxxxxxxx"
   #   }
   # }
 }

# Módulo para pegar uma VPC já existente
# module "vpc_data" {
#   source   = "../modules/vpc_data"
#   vpc_name = var.vpc_name
# }


module "ecs_cluster" {
  source = "../modules/ecs_cluster"

  vpc_id                      = module.vpc.vpc_id
  #subnets                     = module.vpc_data.private_ids
  subnets                     = module.vpc.private_subnet_ids
  key_name                    = var.key_name
  cluster_name                = var.cluster_name
  instance_type               = var.instance_type
  ami_id                      = data.aws_ami.ecs_optimized.id
  desired_capacity            = var.desired_capacity
  max_size                    = var.max_size
  min_size                    = var.min_size
  volume_size                 = var.volume_size
  volume_type                 = var.volume_type
  associate_public_ip_address = var.associate_public_ip_address
  role_name                   = var.role_name
  tags                        = local.tags
  environment                 = local.environment
  sgname                      = var.sgname
  ecs_instance_profile        = var.ecs_instance_profile
  asg_tag                     = var.asg_tag
  launch_template_name        = var.launch_template_name
  capacity_provider_name      = var.capacity_provider_name
  enable_managed_termination  = var.enable_managed_termination
  target_capacity_percent     = var.target_capacity_percent
  min_step                    = var.min_step
  max_step                    = var.max_step
  default_weight              = var.default_weight
  default_base                = var.default_base
  # additional_rules_security_group = {
  #   ingress_rule_1 = {
  #     from_port   = 0
  #     to_port     = 0
  #     protocol    = "-1"
  #     cidr_blocks = ["10.10.0.0/16"]
  #     description = "VPN"
  #     type        = "ingress"
  #   },
  # }
}

module "ecs_services" {
  source   = "../modules/ecs_service"
  for_each = var.services

  cluster_name      = module.ecs_cluster.ecs_cluster_name
  capacity_provider = var.capacity_provider_name

  service_name   = each.key
  task_family    = lookup(each.value, "task_family", each.key)
  container_name = lookup(each.value, "container_name", each.key)

  image  = each.value.image
  cpu    = each.value.task_cpu
  memory = each.value.task_memory

  container_cpu                      = lookup(each.value, "container_cpu", null)
  container_memory                   = lookup(each.value, "container_memory", null)
  container_memory_reservation       = lookup(each.value, "container_memory_reservation", null)
  container_port                     = lookup(each.value, "container_port", null)
  desired_count                      = lookup(each.value, "desired_count", 1)
  environment_variables              = lookup(each.value, "env", {})
  secrets                            = lookup(each.value, "secrets", [])
  command                            = lookup(each.value, "command", [])
  entrypoint                         = lookup(each.value, "entrypoint", [])
  health_check                       = lookup(each.value, "health_check", null)
  volumes                            = lookup(each.value, "volumes", [])
  load_balancers                     = lookup(each.value, "load_balancers", [])
  execution_role_arn                 = lookup(each.value, "execution_role_arn", null)
  task_role_arn                      = lookup(each.value, "task_role_arn", null)
  capacity_provider_weight           = lookup(each.value, "capacity_provider_weight", 1)
  capacity_provider_base             = lookup(each.value, "capacity_provider_base", 0)
  deployment_minimum_healthy_percent = lookup(each.value, "deployment_minimum_healthy_percent", 50)
  deployment_maximum_percent         = lookup(each.value, "deployment_maximum_percent", 200)
  enable_execute_command             = lookup(each.value, "enable_execute_command", false)

  subnets          = module.vpc.private_subnet_ids
  security_groups  = [module.ecs_cluster.security_group_id]
  assign_public_ip = lookup(each.value, "assign_public_ip", false)

  enable_cloudwatch_logging              = lookup(each.value, "enable_cloudwatch_logging", true)
  create_cloudwatch_log_group            = lookup(each.value, "create_cloudwatch_log_group", true)
  cloudwatch_log_group_name              = lookup(each.value, "cloudwatch_log_group_name", null)
  cloudwatch_log_group_use_name_prefix   = lookup(each.value, "cloudwatch_log_group_use_name_prefix", false)
  cloudwatch_log_group_retention_in_days = lookup(each.value, "cloudwatch_log_group_retention_in_days", 30)
  cloudwatch_log_group_kms_key_id        = lookup(each.value, "cloudwatch_log_group_kms_key_id", null)

  tags = merge(local.tags, lookup(each.value, "tags", {}))
}
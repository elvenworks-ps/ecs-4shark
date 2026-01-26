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

data "aws_route53_zone" "private" {
  name         = var.private_zone_name
  private_zone = true
}

module "vpc_data" {
  source   = "../modules/vpc_data"
  vpc_name = var.vpc_name
}

module "internal_alb" {
  source = "../modules/internal_alb"

  name_prefix       = var.alb_name_prefix
  vpc_id            = module.vpc_data.vpc_id
  subnet_ids        = module.vpc_data.private_ids
  record_name       = var.alb_record_name
  private_zone_id   = data.aws_route53_zone.private.zone_id
  alb_ingress_cidrs = var.alb_ingress_cidrs
  tags              = local.tags

  enable_blue_green                 = var.enable_blue_green
  production_listener_rule_priority = var.production_listener_rule_priority
  blue_green_test_path              = var.blue_green_test_path
  blue_green_test_priority          = var.blue_green_test_priority

  # Health check otimizado para deploys rápidos
  health_check_path                = "/health"
  health_check_matcher             = "200-399" # Aceita redirects e outros códigos de sucesso
  health_check_interval            = 10        # 10s ao invés de 30s
  health_check_timeout             = 5
  health_check_healthy_threshold   = 2 # 2 checks (20s) ao invés de 5 (150s)
  health_check_unhealthy_threshold = 3 # 3 falhas antes de marcar unhealthy

  # Rollbacks mais rápidos
  deregistration_delay = 30 # 30s ao invés de 300s default
}

module "ecs_cluster" {
  depends_on = [module.ecr]
  source     = "../modules/ecs_cluster"

  vpc_id                      = module.vpc_data.vpc_id
  subnets                     = module.vpc_data.private_ids
  key_name                    = var.key_name
  create_key_pair             = false
  manage_iam                  = true
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
}

module "ecs_services" {
  source      = "../modules/ecs_service"
  for_each    = local.services
  environment = var.environment
  depends_on  = [module.ecs_cluster]

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
  enable_deployment_circuit_breaker  = lookup(each.value, "enable_deployment_circuit_breaker", true)
  deployment_rollback                = lookup(each.value, "deployment_rollback", true)
  advanced_configuration             = lookup(each.value, "advanced_configuration", null)
  deployment_strategy                = lookup(each.value, "deployment_strategy", null)
  bake_time_in_minutes               = lookup(each.value, "bake_time_in_minutes", null)
  deployment_controller_type         = lookup(each.value, "deployment_controller_type", null)
  enable_execute_command             = lookup(each.value, "enable_execute_command", false)

  # Grace period: espera antes de verificar health do ALB (evita terminar tasks prematuramente)
  health_check_grace_period_seconds = lookup(each.value, "health_check_grace_period_seconds", 60)

  subnets          = module.vpc_data.private_ids
  security_groups  = [module.ecs_cluster.security_group_id]
  assign_public_ip = lookup(each.value, "assign_public_ip", false)

  enable_cloudwatch_logging              = lookup(each.value, "enable_cloudwatch_logging", true)
  create_cloudwatch_log_group            = lookup(each.value, "create_cloudwatch_log_group", false)
  cloudwatch_log_group_name              = lookup(each.value, "cloudwatch_log_group_name", null)
  cloudwatch_log_group_use_name_prefix   = lookup(each.value, "cloudwatch_log_group_use_name_prefix", false)
  cloudwatch_log_group_retention_in_days = lookup(each.value, "cloudwatch_log_group_retention_in_days", 30)
  cloudwatch_log_group_kms_key_id        = lookup(each.value, "cloudwatch_log_group_kms_key_id", null)

  tags = merge(local.tags, lookup(each.value, "tags", {}))
}

module "ecr" {
  source = "../modules/ecr"

  for_each = var.ecr_repositories

  name = each.value

  tags = {
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

# =============================================================================
# CodeDeploy Blue/Green para Web Service
# =============================================================================
module "codedeploy_web" {
  source = "../modules/codedeploy"

  environment = var.environment
  app_name    = "web"

  cluster_name = module.ecs_cluster.ecs_cluster_name
  service_name = var.service_with_alb

  listener_arn                = module.internal_alb.listener_arn
  target_group_name           = module.internal_alb.target_group_name
  alternate_target_group_name = module.internal_alb.alternate_target_group_name

  deployment_config_name           = "CodeDeployDefault.ECSAllAtOnce"
  termination_wait_time_in_minutes = 5

  # Criar recursos via Terraform
  create_iam_role       = true
  create_codedeploy_app = true

  tags = local.tags

  depends_on = [
    module.ecs_services,
    module.internal_alb
  ]
}

# =============================================================================
# IAM Policy para Deploy (GitHub Actions)
# =============================================================================
module "iam_deploy" {
  source = "../modules/iam_deploy"

  environment        = var.environment
  policy_name_prefix = "app-staging"
  cluster_name       = "${var.environment}-001-cluster"

  ecr_repository_arns = [
    for repo in var.ecr_repositories :
    "arn:aws:ecr:us-east-1:405749097490:repository/${repo}"
  ]

  task_execution_role_arns = [
    "arn:aws:iam::405749097490:role/ecsTaskExecutionRole"
  ]

  enable_codedeploy                = true
  codedeploy_app_name              = module.codedeploy_web.app_name
  codedeploy_deployment_group_name = module.codedeploy_web.deployment_group_name

  iam_user_name = "app-staging"

  # Criar policy via Terraform
  create_policy = true

  tags = local.tags
}

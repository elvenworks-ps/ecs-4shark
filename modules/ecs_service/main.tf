resource "aws_cloudwatch_log_group" "this" {
  count = var.enable_cloudwatch_logging && var.create_cloudwatch_log_group ? 1 : 0

  name              = var.cloudwatch_log_group_use_name_prefix ? null : local.log_group_name
  name_prefix       = var.cloudwatch_log_group_use_name_prefix ? "${local.log_group_name}-" : null
  retention_in_days = var.cloudwatch_log_group_retention_in_days
  kms_key_id        = var.cloudwatch_log_group_kms_key_id

  tags = var.tags
}

resource "aws_ecs_task_definition" "this" {
  family                   = var.task_family
  network_mode             = "awsvpc"
  requires_compatibilities = ["EC2"]
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.task_role_arn

  container_definitions = jsonencode([
    {
      name                   = var.container_name
      image                  = var.image
      cpu                    = var.container_cpu
      memoryReservation      = var.container_memory_reservation
      memory                 = var.container_memory
      essential              = true
      command                = length(var.command) > 0 ? var.command : null
      entryPoint             = length(var.entrypoint) > 0 ? var.entrypoint : null
      environment            = local.environment_list
      secrets                = var.secrets
      portMappings           = var.container_port == null ? [] : [{ containerPort = var.container_port, hostPort = var.container_port, protocol = "tcp" }]
      healthCheck            = var.health_check
      logConfiguration = var.enable_cloudwatch_logging ? {
        logDriver = "awslogs"
        options = {
          awslogs-group         = try(aws_cloudwatch_log_group.this[0].name, local.log_group_name)
          awslogs-region        = data.aws_region.current.id
          awslogs-stream-prefix = "ecs"
        }
      } : null
    }
  ])

  dynamic "volume" {
    for_each = var.volumes
    content {
      name      = volume.value.name
      host_path = try(volume.value.host_path, null)
    }
  }
}

resource "aws_ecs_service" "this" {
  name            = var.service_name
  cluster         = var.cluster_name
  desired_count   = var.desired_count
  task_definition = aws_ecs_task_definition.this.arn

  capacity_provider_strategy {
    capacity_provider = var.capacity_provider
    weight            = var.capacity_provider_weight
    base              = var.capacity_provider_base
  }

  network_configuration {
    subnets          = var.subnets
    security_groups  = var.security_groups
    assign_public_ip = var.assign_public_ip
  }

  dynamic "load_balancer" {
    for_each = var.load_balancers
    content {
      target_group_arn = load_balancer.value.target_group_arn
      container_name   = load_balancer.value.container_name
      container_port   = load_balancer.value.container_port
    }
  }

  enable_execute_command = var.enable_execute_command

  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent
  deployment_maximum_percent         = var.deployment_maximum_percent

  tags = var.tags

  depends_on = [
    aws_cloudwatch_log_group.this
  ]
}

data "aws_region" "current" {}

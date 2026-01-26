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
  network_mode             = "bridge"
  requires_compatibilities = ["EC2"]
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.task_role_arn

  container_definitions = jsonencode([
    {
      name              = var.container_name
      image             = var.image
      cpu               = var.container_cpu
      memoryReservation = var.container_memory_reservation
      memory            = var.container_memory
      essential         = true

      command     = length(var.command) > 0 ? var.command : null
      entryPoint  = length(var.entrypoint) > 0 ? var.entrypoint : null
      environment = local.environment_list
      secrets     = var.secrets

      # IMPORTANTE:
      # - Se você quer escalar tasks por instância sem conflito, use hostPort = 0.
      # - Se você precisa fixar porta no host (1 task por EC2), deixe hostPort = var.container_port.
      portMappings = var.container_port == null ? [] : [{
        containerPort = var.container_port
        hostPort      = 0
        protocol      = "tcp"
      }]

      healthCheck = var.health_check

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

  # Grace period: tempo que o ECS espera antes de verificar health do ALB
  # Evita que tasks sejam terminadas prematuramente durante startup
  health_check_grace_period_seconds = length(var.load_balancers) > 0 ? var.health_check_grace_period_seconds : null

  capacity_provider_strategy {
    capacity_provider = var.capacity_provider
    weight            = var.capacity_provider_weight
    base              = var.capacity_provider_base
  }

  # Para CODE_DEPLOY: load_balancer é obrigatório para o setup inicial
  # O CodeDeploy vai gerenciar os target groups durante deployments
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

  # deployment_configuration só é usado quando deployment_controller_type NÃO é CODE_DEPLOY
  dynamic "deployment_configuration" {
    for_each = var.deployment_strategy != null && var.deployment_controller_type != "CODE_DEPLOY" ? [1] : []
    content {
      strategy             = var.deployment_strategy
      bake_time_in_minutes = var.bake_time_in_minutes
    }
  }

  # Circuit breaker só é usado quando deployment_controller_type NÃO é CODE_DEPLOY
  dynamic "deployment_circuit_breaker" {
    for_each = var.enable_deployment_circuit_breaker && var.deployment_controller_type != "CODE_DEPLOY" ? [true] : []
    content {
      enable   = true
      rollback = var.deployment_rollback
    }
  }

  dynamic "deployment_controller" {
    for_each = var.deployment_controller_type == null ? [] : [var.deployment_controller_type]
    content {
      type = deployment_controller.value
    }
  }

  tags = var.tags

  depends_on = [
    aws_cloudwatch_log_group.this
  ]

  lifecycle {
    ignore_changes = [
      load_balancer,
      desired_count,
      task_definition, # CodeDeploy gerencia a task definition durante deployments
    ]
  }
}
data "aws_region" "current" {}

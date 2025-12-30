data "aws_vpc" "selected" {
  tags = {
    Name = "${var.vpc_name}*"
  }
}

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }

  tags = {
    Name = "*public*"
  }
}

data "aws_subnet" "selected_public" {
  count = length(data.aws_subnets.public.ids)
  id    = tolist(data.aws_subnets.public.ids)[count.index]
}

# ---------------------------------------------------------------

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }

  tags = {
    Name = "*private*"
  }
}

data "aws_subnet" "selected_private" {
  count = length(data.aws_subnets.private.ids)
  id    = tolist(data.aws_subnets.private.ids)[count.index]
}

resource "aws_ecs_cluster" "cluster" {
  name = format("%s-%s", var.cluster_name, var.environment)
  tags = {
    Name        = "${var.cluster_name}"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_ecs_task_definition" "app_task" {
  family                   = "${var.cluster_name}-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = aws_iam_role.execution_role.arn
  # task_role_arn            = ""

  container_definitions = jsonencode([
    local.container_definition
  ])
}

# Criação da IAM Role para Fargate
resource "aws_iam_role" "execution_role" {
  name = "${var.cluster_name}-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_execution_policy" {
  role       = aws_iam_role.execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

#Fargate
resource "aws_ecs_service" "fargate_service" {
  name            = var.service
  cluster         = aws_ecs_cluster.cluster.id
  launch_type     = "FARGATE"
  task_definition = aws_ecs_task_definition.app_task.arn
  desired_count   = var.desired_count
  network_configuration {
    subnets          = data.aws_subnets.private.ids
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = false
  }

  tags = {
    Name        = "${var.cluster_name}"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity       = var.max_capacity
  min_capacity       = var.min_capacity
  resource_id = "service/${aws_ecs_cluster.cluster.name}/${aws_ecs_service.fargate_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

    depends_on = [aws_ecs_service.fargate_service]
}

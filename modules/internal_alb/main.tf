locals {
  name_prefix_sanitized = replace(lower(var.name_prefix), "[^a-z0-9-]", "-")
  lb_name               = substr("${local.name_prefix_sanitized}-lb", 0, 32)
  target_group_name     = substr("${local.name_prefix_sanitized}-tg", 0, 32)
  alt_target_group_name = substr("${local.name_prefix_sanitized}-alt-tg", 0, 32)
  bluegreen_role_name   = substr("${local.name_prefix_sanitized}-ecs-bg-role", 0, 64)
}

resource "aws_iam_role" "ecs_bluegreen" {
  count = var.enable_blue_green ? 1 : 0

  name = local.bluegreen_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ecs.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy" "ecs_bluegreen" {
  count = var.enable_blue_green ? 1 : 0

  name = "${local.bluegreen_role_name}-elb"
  role = aws_iam_role.ecs_bluegreen[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "elasticloadbalancing:ModifyRule",
          "elasticloadbalancing:ModifyListener",
          "elasticloadbalancing:DescribeRules",
          "elasticloadbalancing:DescribeListeners",
          "elasticloadbalancing:DescribeTargetGroups",
          "elasticloadbalancing:DescribeTargetHealth",
          "elasticloadbalancing:RegisterTargets",
          "elasticloadbalancing:DeregisterTargets"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_security_group" "alb" {
  count = var.create_alb_security_group ? 1 : 0

  name_prefix = "${substr(local.name_prefix_sanitized, 0, 20)}-alb-"
  description = "ALB security group for ${var.name_prefix}"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP from allowed CIDRs"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.alb_ingress_cidrs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

locals {
  alb_security_group_ids = var.security_group_ids != null ? var.security_group_ids : aws_security_group.alb[*].id
}

resource "aws_lb" "this" {
  name               = local.lb_name
  internal           = true
  load_balancer_type = "application"
  security_groups    = local.alb_security_group_ids
  subnets            = var.subnet_ids
  idle_timeout       = 60

  tags = var.tags
}

resource "aws_lb_target_group" "this" {
  name        = local.target_group_name
  port        = var.target_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  # Menor delay = rollbacks mais rápidos (default AWS é 300s)
  deregistration_delay = var.deregistration_delay

  # Ramp-up gradual de tráfego (0 = desabilitado)
  slow_start = var.slow_start

  health_check {
    enabled             = true
    path                = var.health_check_path
    matcher             = var.health_check_matcher
    protocol            = "HTTP"
    interval            = var.health_check_interval
    timeout             = var.health_check_timeout
    healthy_threshold   = var.health_check_healthy_threshold
    unhealthy_threshold = var.health_check_unhealthy_threshold
    port                = "traffic-port"
  }

  tags = var.tags
}

resource "aws_lb_target_group" "alternate" {
  count = var.enable_blue_green ? 1 : 0

  name        = local.alt_target_group_name
  port        = var.target_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  deregistration_delay = var.deregistration_delay
  slow_start           = var.slow_start

  health_check {
    enabled             = true
    path                = var.health_check_path
    matcher             = var.health_check_matcher
    protocol            = "HTTP"
    interval            = var.health_check_interval
    timeout             = var.health_check_timeout
    healthy_threshold   = var.health_check_healthy_threshold
    unhealthy_threshold = var.health_check_unhealthy_threshold
    port                = "traffic-port"
  }

  tags = var.tags
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }

  # CodeDeploy gerencia o default_action durante Blue/Green deployments
  lifecycle {
    ignore_changes = [default_action]
  }
}

# Listener rules para paths específicos (NÃO usar com Blue/Green CodeDeploy)
# CodeDeploy requer que o tráfego passe pelo default_action do listener
resource "aws_lb_listener_rule" "paths" {
  for_each = var.enable_blue_green ? {} : { for rule in var.listener_rules : rule.priority => rule }

  listener_arn = aws_lb_listener.http.arn
  priority     = each.value.priority

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }

  condition {
    path_pattern {
      values = [each.value.path]
    }
  }

  lifecycle {
    ignore_changes = [action]
  }
}

resource "aws_route53_record" "alb_cname" {
  zone_id = var.private_zone_id
  name    = var.record_name
  type    = "CNAME"
  ttl     = 300
  records = [aws_lb.this.dns_name]
}

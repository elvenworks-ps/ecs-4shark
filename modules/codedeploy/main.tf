# =============================================================================
# CodeDeploy Blue/Green para ECS
# =============================================================================

locals {
  iam_role_arn    = var.create_iam_role ? aws_iam_role.codedeploy[0].arn : var.existing_iam_role_arn
  codedeploy_app  = var.create_codedeploy_app ? aws_codedeploy_app.this[0].name : "${var.environment}-001-${var.app_name}-app"
}

# -----------------------------------------------------------------------------
# IAM Role para CodeDeploy
# -----------------------------------------------------------------------------
resource "aws_iam_role" "codedeploy" {
  count = var.create_iam_role ? 1 : 0

  name = "${var.environment}-001-codedeploy-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "codedeploy.amazonaws.com"
        }
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "codedeploy_ecs" {
  count = var.create_iam_role ? 1 : 0

  role       = aws_iam_role.codedeploy[0].name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS"
}

# -----------------------------------------------------------------------------
# CodeDeploy Application
# -----------------------------------------------------------------------------
resource "aws_codedeploy_app" "this" {
  count = var.create_codedeploy_app ? 1 : 0

  name             = "${var.environment}-001-${var.app_name}-app"
  compute_platform = "ECS"

  tags = var.tags
}

# -----------------------------------------------------------------------------
# CodeDeploy Deployment Group
# -----------------------------------------------------------------------------
resource "aws_codedeploy_deployment_group" "this" {
  app_name               = local.codedeploy_app
  deployment_group_name  = "${var.environment}-001-${var.app_name}-dg"
  service_role_arn       = local.iam_role_arn
  deployment_config_name = var.deployment_config_name

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE", "DEPLOYMENT_STOP_ON_REQUEST"]
  }

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout    = var.action_on_timeout
      wait_time_in_minutes = var.wait_time_in_minutes
    }

    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = var.termination_wait_time_in_minutes
    }
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  ecs_service {
    cluster_name = var.cluster_name
    service_name = var.service_name
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [var.listener_arn]
      }

      target_group {
        name = var.target_group_name
      }

      target_group {
        name = var.alternate_target_group_name
      }

      dynamic "test_traffic_route" {
        for_each = var.test_listener_arn == null ? [] : [var.test_listener_arn]
        content {
          listener_arns = [test_traffic_route.value]
        }
      }
    }
  }

  tags = var.tags
}

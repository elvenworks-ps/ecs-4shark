# =============================================================================
# IAM Policy para Deploy (GitHub Actions / CI/CD)
# =============================================================================

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
  region     = data.aws_region.current.id
}

resource "aws_iam_policy" "deploy" {
  count = var.create_policy ? 1 : 0

  name        = "${var.policy_name_prefix}-deploy-${var.environment}"
  description = "Permissions for deployment in ${var.environment} environment"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = concat(
      # ECR Auth
      [
        {
          Sid      = "ECRAuth"
          Effect   = "Allow"
          Action   = ["ecr:GetAuthorizationToken"]
          Resource = "*"
        }
      ],
      # ECR Push/Pull
      length(var.ecr_repository_arns) > 0 ? [
        {
          Sid    = "ECRPushPull"
          Effect = "Allow"
          Action = [
            "ecr:BatchCheckLayerAvailability",
            "ecr:GetDownloadUrlForLayer",
            "ecr:BatchGetImage",
            "ecr:InitiateLayerUpload",
            "ecr:UploadLayerPart",
            "ecr:CompleteLayerUpload",
            "ecr:PutImage"
          ]
          Resource = var.ecr_repository_arns
        }
      ] : [],
      # ECS Task Definitions
      [
        {
          Sid    = "ECSTaskDef"
          Effect = "Allow"
          Action = [
            "ecs:RegisterTaskDefinition",
            "ecs:DescribeTaskDefinition",
            "ecs:ListTaskDefinitions"
          ]
          Resource = "*"
        }
      ],
      # ECS Cluster/Services
      [
        {
          Sid    = "ECSClusterAll"
          Effect = "Allow"
          Action = [
            "ecs:DescribeClusters",
            "ecs:DescribeServices",
            "ecs:UpdateService",
            "ecs:ListServices",
            "ecs:ListTasks",
            "ecs:DescribeTasks",
            "ecs:DescribeContainerInstances"
          ]
          Resource = [
            "arn:aws:ecs:${local.region}:${local.account_id}:cluster/${var.cluster_name}",
            "arn:aws:ecs:${local.region}:${local.account_id}:service/${var.cluster_name}/*",
            "arn:aws:ecs:${local.region}:${local.account_id}:task/${var.cluster_name}/*",
            "arn:aws:ecs:${local.region}:${local.account_id}:container-instance/${var.cluster_name}/*"
          ]
        }
      ],
      # ALB
      [
        {
          Sid      = "ALB"
          Effect   = "Allow"
          Action   = ["elasticloadbalancing:Describe*"]
          Resource = "*"
        }
      ],
      # CloudWatch Logs
      [
        {
          Sid      = "Logs"
          Effect   = "Allow"
          Action   = ["logs:CreateLogStream", "logs:PutLogEvents"]
          Resource = "arn:aws:logs:${local.region}:${local.account_id}:log-group:/ecs/${var.environment}-*:*"
        }
      ],
      # IAM PassRole
      length(var.task_execution_role_arns) > 0 ? [
        {
          Sid      = "PassRole"
          Effect   = "Allow"
          Action   = "iam:PassRole"
          Resource = var.task_execution_role_arns
          Condition = {
            StringEquals = {
              "iam:PassedToService" = "ecs-tasks.amazonaws.com"
            }
          }
        }
      ] : [],
      # CodeDeploy (opcional)
      var.enable_codedeploy ? [
        {
          Sid    = "CodeDeploy"
          Effect = "Allow"
          Action = [
            "codedeploy:CreateDeployment",
            "codedeploy:GetDeployment",
            "codedeploy:GetDeploymentConfig",
            "codedeploy:GetDeploymentGroup",
            "codedeploy:RegisterApplicationRevision",
            "codedeploy:GetApplicationRevision",
            "codedeploy:StopDeployment",
            "codedeploy:ContinueDeployment",
            "codedeploy:GetApplication"
          ]
          Resource = [
            "arn:aws:codedeploy:${local.region}:${local.account_id}:application:${var.codedeploy_app_name}",
            "arn:aws:codedeploy:${local.region}:${local.account_id}:deploymentgroup:${var.codedeploy_app_name}/${var.codedeploy_deployment_group_name}",
            "arn:aws:codedeploy:${local.region}:${local.account_id}:deploymentconfig:*"
          ]
        }
      ] : []
    )
  })

  tags = var.tags
}

resource "aws_iam_user_policy_attachment" "deploy" {
  count = var.create_policy && var.iam_user_name != null ? 1 : 0

  user       = var.iam_user_name
  policy_arn = aws_iam_policy.deploy[0].arn
}

#Defining the Application Load Balancer
resource "aws_alb" "application_load_balancer" {
  name                      = "${var.alb_name}alb-${var.environment}"
  internal                  = false
  load_balancer_type        = "application"
  subnets                   = data.aws_subnets.public.ids
  security_groups           = [aws_security_group.alb_sg.id]
}

#Defining the target group and a health check on the application
resource "aws_lb_target_group" "target_group" {
  name                      = "test-tg"
  port                      = "3000"
  protocol                  = "HTTP"
  target_type               = "ip"
  vpc_id                    = data.aws_vpc.selected.id
  health_check {
      path                  = "/health"
      protocol              = "HTTP"
      matcher               = "200"
      port                  = "traffic-port"
      healthy_threshold     = 2
      unhealthy_threshold   = 2
      timeout               = 10
      interval              = 30
  }
}

#Defines an HTTP Listener for the ALB
resource "aws_lb_listener" "listener" {
  load_balancer_arn         = aws_alb.application_load_balancer.arn
  port                      = "80"
  protocol                  = "HTTP"

  default_action {
    type                    = "forward"
    target_group_arn        = aws_lb_target_group.target_group.arn
  }
}

resource "aws_security_group" "ecs_sg" {
    vpc_id                      = data.aws_vpc.selected.id
    name                        = "${var.alb_name}-alb-sg"
    description                 = "Security group for ecs app"
    revoke_rules_on_delete      = true

    tags = {
    Name        = "${var.alb_name}-ecs-sg"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# ------------------------------------------------------------------------------
# ECS app Security Group Rules - INBOUND
# ------------------------------------------------------------------------------
resource "aws_security_group_rule" "ecs_alb_ingress" {
    type                        = "ingress"
    from_port                   = 3000
    to_port                     = 3000
    protocol                    = "tcp"
    description                 = "Allow inbound traffic from ALB"
    security_group_id           = aws_security_group.ecs_sg.id
    source_security_group_id    = aws_security_group.alb_sg.id
}
# ------------------------------------------------------------------------------
# ECS app Security Group Rules - OUTBOUND
# ------------------------------------------------------------------------------
resource "aws_security_group_rule" "ecs_all_egress" {
    type                        = "egress"
    from_port                   = 0
    to_port                     = 0
    protocol                    = "-1"
    description                 = "Allow outbound traffic from ECS"
    security_group_id           = aws_security_group.ecs_sg.id
    cidr_blocks                 = ["0.0.0.0/0"]
}

# ------------------------------------------------------------------------------
# Security Group for alb
# ------------------------------------------------------------------------------
resource "aws_security_group" "alb_sg" {
    vpc_id                      = data.aws_vpc.selected.id
    name                        = "demo-sg-alb"
    description                 = "Security group for alb"
    revoke_rules_on_delete      = true
}
# ------------------------------------------------------------------------------
# Alb Security Group Rules - INBOUND
# ------------------------------------------------------------------------------
resource "aws_security_group_rule" "alb_http_ingress" {
    type                        = "ingress"
    from_port                   = 80
    to_port                     = 80
    protocol                    = "TCP"
    description                 = "Allow http inbound traffic from internet"
    security_group_id           = aws_security_group.alb_sg.id
    cidr_blocks                 = ["0.0.0.0/0"]
}
resource "aws_security_group_rule" "alb_https_ingress" {
    type                        = "ingress"
    from_port                   = 443
    to_port                     = 443
    protocol                    = "TCP"
    description                 = "Allow https inbound traffic from internet"
    security_group_id           = aws_security_group.alb_sg.id
    cidr_blocks                 = ["0.0.0.0/0"]
}
# ------------------------------------------------------------------------------
# Alb Security Group Rules - OUTBOUND
# ------------------------------------------------------------------------------
resource "aws_security_group_rule" "alb_egress" {
    type                        = "egress"
    from_port                   = 0
    to_port                     = 0
    protocol                    = "-1"
    description                 = "Allow outbound traffic from alb"
    security_group_id           = aws_security_group.alb_sg.id
    cidr_blocks                 = ["0.0.0.0/0"]
}

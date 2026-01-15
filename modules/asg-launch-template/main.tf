###########################
# Security Group condicional
###########################
resource "aws_security_group" "this" {
  count       = var.create_security_group ? 1 : 0
  name_prefix = "${var.name}-sg"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.sg_ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  dynamic "egress" {
    for_each = var.sg_egress_rules
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }

  tags = merge(var.tags, { Name = "${var.name}-sg" })
}

###########################
# Launch Template
###########################
resource "aws_launch_template" "this" {
  name_prefix   = var.name
  image_id      = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name

  vpc_security_group_ids = var.create_security_group ? [aws_security_group.this[0].id] : var.security_groups

  user_data = base64encode(var.user_data)

  tag_specifications {
    resource_type = "instance"
    tags          = var.tags
  }

  tags = var.tags

  # Define a versão padrão sempre como a mais recente
  update_default_version = true
}

###########################
# Auto Scaling Group
###########################
resource "aws_autoscaling_group" "this" {
  name                      = "${var.name}-asg"
  max_size                  = var.max_size
  min_size                  = var.min_size
  desired_capacity          = var.desired_capacity
  vpc_zone_identifier       = var.subnet_ids
  health_check_type         = "EC2"
  force_delete              = true

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

  # Target Group opcional (para ALB/NLB)
  target_group_arns = var.target_group_arns

  termination_policies = ["OldestInstance", "Default"]

  tag {
    key                 = "Name"
    value               = var.name
    propagate_at_launch = true
  }

  dynamic "tag" {
    for_each = var.tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}

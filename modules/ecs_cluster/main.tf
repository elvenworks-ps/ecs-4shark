data "aws_subnet" "this" {
  id = var.subnets[0]
}

data "aws_vpc" "this" {
  id = data.aws_subnet.this.vpc_id
}

locals {
  ingress_with_source_security_group = merge(
    {
      ingress_access = {
        description = "Access vpc"
        protocol    = "-1"
        from_port   = 0
        to_port     = 0
        cidr_blocks = [data.aws_vpc.this.cidr_block]
      }
    },
    var.additional_rules_security_group,
  )
}

resource "aws_ecs_cluster" "cluster" {
  name = format("%s-%s", var.environment, var.cluster_name)
}

# Criação da IAM Role para EC2
resource "aws_iam_role" "ecs_instance_role" {
  name = var.role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

# Anexa a política "AmazonEC2ContainerServiceforEC2Role" à IAM Role
resource "aws_iam_role_policy_attachment" "ecs_policy_attach1" {
  role       = aws_iam_role.ecs_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "ecs_policy_attach2" {
  role       = aws_iam_role.ecs_instance_role.name
  policy_arn = "arn:aws:iam::405749097490:policy/4shark-ECSInfrastructurePolicy"
}

# Criação do Instance Profile para associar a role
resource "aws_iam_instance_profile" "ecs_instance_profile" {
  name = var.ecs_instance_profile
  role = aws_iam_role.ecs_instance_role.name
}

resource "tls_private_key" "this" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "this" {
  key_name   = var.key_name
  public_key = tls_private_key.this.public_key_openssh

  tags = merge(
    {
      "Name" = "${var.cluster_name}-key-pair"
    },
    var.tags
  )
}

resource "local_file" "private_key" {
  filename        = "${path.module}/${var.key_name}.pem"
  content         = tls_private_key.this.private_key_pem
  file_permission = "0600"
}

# Launch Template para ECS
resource "aws_launch_template" "ecs_instance_template" {
  name_prefix   = var.launch_template_name
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = aws_key_pair.this.key_name

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = var.volume_size
      volume_type = var.volume_type
    }
  }

  network_interfaces {
    associate_public_ip_address = var.associate_public_ip_address
    security_groups             = [aws_security_group.ecs_sg.id]
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.ecs_instance_profile.name
  }

  user_data = base64encode(<<-EOF
              #!/bin/bash
              echo ECS_CLUSTER=${aws_ecs_cluster.cluster.name} >> /etc/ecs/ecs.config
              EOF
  )
}

# Auto Scaling Group
resource "aws_autoscaling_group" "ecs_asg" {
  desired_capacity    = var.desired_capacity
  max_size            = var.max_size
  min_size            = var.min_size
  vpc_zone_identifier = var.subnets

  launch_template {
    id      = aws_launch_template.ecs_instance_template.id
    version = aws_launch_template.ecs_instance_template.latest_version
  }

  tag {
    key                 = "Name"
    value               = var.asg_tag
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }

  # Atualização automática de instâncias com novas versões do Launch Template
  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 90
    }
    # triggers = ["launch_template"]
  }
}

resource "aws_ecs_capacity_provider" "this" {
  name = var.capacity_provider_name

  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.ecs_asg.arn
    managed_termination_protection = var.enable_managed_termination ? "ENABLED" : "DISABLED"

    managed_scaling {
      status                    = "ENABLED"
      target_capacity           = var.target_capacity_percent
      minimum_scaling_step_size = var.min_step
      maximum_scaling_step_size = var.max_step
    }
  }
}

resource "aws_ecs_cluster_capacity_providers" "this" {
  cluster_name       = aws_ecs_cluster.cluster.name
  capacity_providers = [aws_ecs_capacity_provider.this.name]

  default_capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.this.name
    weight            = var.default_weight
    base              = var.default_base
  }
}


# Configuração de Auto Scaling Policy
resource "aws_autoscaling_policy" "scale_up" {
  name                   = "scale-up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  autoscaling_group_name = aws_autoscaling_group.ecs_asg.name
}

resource "aws_autoscaling_policy" "scale_down" {
  name                   = "scale-down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  autoscaling_group_name = aws_autoscaling_group.ecs_asg.name
}


# # Security Group para ECS
resource "aws_security_group" "ecs_sg" {
  vpc_id = var.vpc_id

  dynamic "ingress" {
    for_each = local.ingress_with_source_security_group
    content {
      description = ingress.value.description
      protocol    = ingress.value.protocol
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.sgname}"
  }
}

locals {
  atento = {
    ami              = var.ami_atento
    # Cleansing e Migration estão como 0 configuradas diretamente no "module"
    min_size         = 1
    max_size         = 16
    desired_capacity = 1
  }

  shared = {
    ami              = var.ami_shared
    # Cleansing, Migration, commission_tiger_shark e commission_white_shark estão como 0 configuradas diretamente no "module"
    min_size         = 1
    max_size         = 16
    desired_capacity = 1
  }

  beta = {
    ami              = var.ami_beta
    # Cleansing, Migration, commission_tiger_shark e commission_white_shark estão como 0 configuradas diretamente no "module"
    min_size         = 0
    max_size         = 6
    desired_capacity = 0
  }

  demo = {
    ami              = var.ami_demo
    # Cleansing, Migration, commission_tiger_shark e commission_white_shark estão como 0 configuradas diretamente no "module"
    min_size         = 1
    max_size         = 6
    desired_capacity = 1
  }
}
module "asg-worker-atento-cleansing" {
  source = "./modules/asg-launch-template"

  name              = "worker-atento-cleansing"
  ami               = local.atento.ami
  instance_type     = "t3a.small"
  key_name          = "4Shark-prd"
  subnet_ids        = ["subnet-043bc50dc26aeabe4", "subnet-0a2a3cf53344bb353"]
  min_size          = var.atento_cleansing_min_size
  max_size          = var.atento_cleansing_max_size
  desired_capacity  = var.atento_cleansing_desired_capacity


  create_security_group = false
  security_groups       = ["sg-017f04587a743355e"] # Use this if not creating a new SG
  vpc_id                = "vpc-0204a1f8b5de51941"

  # sg_ingress_rules = [
  #   {
  #     from_port   = 80
  #     to_port     = 80
  #     protocol    = "tcp"
  #     cidr_blocks = ["0.0.0.0/0"]
  #   }
  # ]
  user_data = <<-EOT
              #!/bin/bash
              echo cleansing > /app/app/nome-do-worker.txt
              EOT

  target_group_arns = []

  tags = {
    Environment = "prod"
    ManagedBy   = "Terraform"
  }
}

module "asg-worker-atento-commission" {
  source = "./modules/asg-launch-template"

  name              = "worker-atento-commission"
  ami               = local.atento.ami
  instance_type     = "t3a.small"
  key_name          = "4Shark-prd"
  subnet_ids        = ["subnet-043bc50dc26aeabe4", "subnet-0a2a3cf53344bb353"]
  min_size          = var.atento_commission_min_size
  max_size          = var.atento_commission_max_size
  desired_capacity  = var.atento_commission_desired_capacity

  create_security_group = false
  security_groups       = ["sg-017f04587a743355e"] # Use this if not creating a new SG
  vpc_id                = "vpc-0204a1f8b5de51941"

  # sg_ingress_rules = [
  #   {
  #     from_port   = 80
  #     to_port     = 80
  #     protocol    = "tcp"
  #     cidr_blocks = ["0.0.0.0/0"]
  #   }
  # ]
  user_data = <<-EOT
              #!/bin/bash
              echo commission > /app/app/nome-do-worker.txt
              EOT

  target_group_arns = []

  tags = {
    Environment = "prod"
    ManagedBy   = "Terraform"
  }
}

module "asg-worker-atento-commission_tiger_shark" {
  source = "./modules/asg-launch-template"

  name              = "worker-atento-commission_tiger_shark"
  ami               = local.atento.ami
  instance_type     = "t3a.small"
  key_name          = "4Shark-prd"
  subnet_ids        = ["subnet-043bc50dc26aeabe4", "subnet-0a2a3cf53344bb353"]
  min_size          = var.atento_commission_tiger_shark_min_size
  max_size          = var.atento_commission_tiger_shark_max_size
  desired_capacity  = var.atento_commission_tiger_shark_desired_capacity


  create_security_group = false
  security_groups       = ["sg-017f04587a743355e"] # Use this if not creating a new SG
  vpc_id                = "vpc-0204a1f8b5de51941"

  # sg_ingress_rules = [
  #   {
  #     from_port   = 80
  #     to_port     = 80
  #     protocol    = "tcp"
  #     cidr_blocks = ["0.0.0.0/0"]
  #   }
  # ]
  user_data = <<-EOT
              #!/bin/bash
              echo commission_tiger_shark > /app/app/nome-do-worker.txt
              EOT

  target_group_arns = []

  tags = {
    Environment = "prod"
    ManagedBy   = "Terraform"
  }
}

module "asg-worker-atento-commission_white_shark" {
  source = "./modules/asg-launch-template"

  name              = "worker-atento-commission_white_shark"
  ami               = local.atento.ami
  instance_type     = "t3a.small"
  key_name          = "4Shark-prd"
  subnet_ids        = ["subnet-043bc50dc26aeabe4", "subnet-0a2a3cf53344bb353"]
  min_size          = var.atento_commission_white_shark_min_size
  max_size          = var.atento_commission_white_shark_max_size
  desired_capacity  = var.atento_commission_white_shark_desired_capacity


  create_security_group = false
  security_groups       = ["sg-017f04587a743355e"] # Use this if not creating a new SG
  vpc_id                = "vpc-0204a1f8b5de51941"

  # sg_ingress_rules = [
  #   {
  #     from_port   = 80
  #     to_port     = 80
  #     protocol    = "tcp"
  #     cidr_blocks = ["0.0.0.0/0"]
  #   }
  # ]
  user_data = <<-EOT
              #!/bin/bash
              echo commission_white_shark > /app/app/nome-do-worker.txt
              EOT

  target_group_arns = []

  tags = {
    Environment = "prod"
    ManagedBy   = "Terraform"
  }
}

module "asg-worker-atento-migration" {
  source = "./modules/asg-launch-template"

  name              = "worker-atento-migration"
  ami               = local.atento.ami
  instance_type     = "t3a.small"
  key_name          = "4Shark-prd"
  subnet_ids        = ["subnet-043bc50dc26aeabe4", "subnet-0a2a3cf53344bb353"]
  min_size          = var.atento_migration_min_size
  max_size          = var.atento_migration_max_size
  desired_capacity  = var.atento_migration_desired_capacity


  create_security_group = false
  security_groups       = ["sg-017f04587a743355e"] # Use this if not creating a new SG
  vpc_id                = "vpc-0204a1f8b5de51941"

  # sg_ingress_rules = [
  #   {
  #     from_port   = 80
  #     to_port     = 80
  #     protocol    = "tcp"
  #     cidr_blocks = ["0.0.0.0/0"]
  #   }
  # ]
  user_data = <<-EOT
              #!/bin/bash
              echo migration > /app/app/nome-do-worker.txt
              EOT

  target_group_arns = []

  tags = {
    Environment = "prod"
    ManagedBy   = "Terraform"
  }
}

module "asg-worker-atento-system" {
  source = "./modules/asg-launch-template"

  name              = "worker-atento-system"
  ami               = local.atento.ami
  instance_type     = "t3a.small"
  key_name          = "4Shark-prd"
  subnet_ids        = ["subnet-043bc50dc26aeabe4", "subnet-0a2a3cf53344bb353"]
  min_size          = var.atento_system_min_size
  max_size          = var.atento_system_max_size
  desired_capacity  = var.atento_system_desired_capacity

  create_security_group = false
  security_groups       = ["sg-017f04587a743355e"] # Use this if not creating a new SG
  vpc_id                = "vpc-0204a1f8b5de51941"

  # sg_ingress_rules = [
  #   {
  #     from_port   = 80
  #     to_port     = 80
  #     protocol    = "tcp"
  #     cidr_blocks = ["0.0.0.0/0"]
  #   }
  # ]
  user_data = <<-EOT
              #!/bin/bash
              echo system > /app/app/nome-do-worker.txt
              EOT

  target_group_arns = []

  tags = {
    Environment = "prod"
    ManagedBy   = "Terraform"
  }
}

module "asg-worker-atento-user" {
  source = "./modules/asg-launch-template"

  name              = "worker-atento-user"
  ami               = local.atento.ami
  instance_type     = "t3a.small"
  key_name          = "4Shark-prd"
  subnet_ids        = ["subnet-043bc50dc26aeabe4", "subnet-0a2a3cf53344bb353"]
  min_size          = var.atento_user_min_size
  max_size          = var.atento_user_max_size
  desired_capacity  = var.atento_user_desired_capacity

  create_security_group = false
  security_groups       = ["sg-017f04587a743355e"] # Use this if not creating a new SG
  vpc_id                = "vpc-0204a1f8b5de51941"

  # sg_ingress_rules = [
  #   {
  #     from_port   = 80
  #     to_port     = 80
  #     protocol    = "tcp"
  #     cidr_blocks = ["0.0.0.0/0"]
  #   }
  # ]
  user_data = <<-EOT
              #!/bin/bash
              echo user > /app/app/nome-do-worker.txt
              EOT

  target_group_arns = []

  tags = {
    Environment = "prod"
    ManagedBy   = "Terraform"
  }
}

module "asg-worker-shared-cleansing" {
  source = "./modules/asg-launch-template"

  name              = "worker-shared-cleansing"
  ami               = local.shared.ami
  instance_type     = "t3a.small"
  key_name          = "4Shark-prd"
  subnet_ids        = ["subnet-043bc50dc26aeabe4", "subnet-0a2a3cf53344bb353"]
  min_size          = var.shared_cleansing_min_size
  max_size          = var.shared_cleansing_max_size
  desired_capacity  = var.shared_cleansing_desired_capacity

  create_security_group = false
  security_groups       = ["sg-0032e773fe9ad6125"] # Use this if not creating a new SG
  vpc_id                = "vpc-0204a1f8b5de51941"

  # sg_ingress_rules = [
  #   {
  #     from_port   = 80
  #     to_port     = 80
  #     protocol    = "tcp"
  #     cidr_blocks = ["0.0.0.0/0"]
  #   }
  # ]
  user_data = <<-EOT
              #!/bin/bash
              echo cleansing > /app/app/nome-do-worker.txt
              EOT

  target_group_arns = []

  tags = {
    Environment = "prod"
    ManagedBy   = "Terraform"
  }
}

module "asg-worker-shared-commission" {
  source = "./modules/asg-launch-template"

  name              = "worker-shared-commission"
  ami               = local.shared.ami
  instance_type     = "t3a.small"
  key_name          = "4Shark-prd"
  subnet_ids        = ["subnet-043bc50dc26aeabe4", "subnet-0a2a3cf53344bb353"]
  min_size          = var.shared_commission_min_size
  max_size          = var.shared_commission_max_size
  desired_capacity  = var.shared_commission_desired_capacity


  create_security_group = false
  security_groups       = ["sg-0032e773fe9ad6125"] # Use this if not creating a new SG
  vpc_id                = "vpc-0204a1f8b5de51941"

  # sg_ingress_rules = [
  #   {
  #     from_port   = 80
  #     to_port     = 80
  #     protocol    = "tcp"
  #     cidr_blocks = ["0.0.0.0/0"]
  #   }
  # ]
  user_data = <<-EOT
              #!/bin/bash
              echo commission > /app/app/nome-do-worker.txt
              EOT

  target_group_arns = []

  tags = {
    Environment = "prod"
    ManagedBy   = "Terraform"
  }
}

module "asg-worker-shared-commission_tiger_shark" {
  source = "./modules/asg-launch-template"

  name              = "worker-shared-commission_tiger_shark"
  ami               = local.shared.ami
  instance_type     = "t3a.small"
  key_name          = "4Shark-prd"
  subnet_ids        = ["subnet-043bc50dc26aeabe4", "subnet-0a2a3cf53344bb353"]
  min_size          = var.shared_commission_tiger_shark_min_size
  max_size          = var.shared_commission_tiger_shark_max_size
  desired_capacity  = var.shared_commission_tiger_shark_desired_capacity


  create_security_group = false
  security_groups       = ["sg-0032e773fe9ad6125"] # Use this if not creating a new SG
  vpc_id                = "vpc-0204a1f8b5de51941"

  # sg_ingress_rules = [
  #   {
  #     from_port   = 80
  #     to_port     = 80
  #     protocol    = "tcp"
  #     cidr_blocks = ["0.0.0.0/0"]
  #   }
  # ]
  user_data = <<-EOT
              #!/bin/bash
              echo commission_tiger_shark > /app/app/nome-do-worker.txt
              EOT

  target_group_arns = []

  tags = {
    Environment = "prod"
    ManagedBy   = "Terraform"
  }
}

module "asg-worker-shared-commission_white_shark" {
  source = "./modules/asg-launch-template"

  name              = "worker-shared-commission_white_shark"
  ami               = local.shared.ami
  instance_type     = "t3a.small"
  key_name          = "4Shark-prd"
  subnet_ids        = ["subnet-043bc50dc26aeabe4", "subnet-0a2a3cf53344bb353"]
  min_size          = var.shared_commission_white_shark_min_size
  max_size          = var.shared_commission_white_shark_max_size
  desired_capacity  = var.shared_commission_white_shark_desired_capacity

  create_security_group = false
  security_groups       = ["sg-0032e773fe9ad6125"] # Use this if not creating a new SG
  vpc_id                = "vpc-0204a1f8b5de51941"

  # sg_ingress_rules = [
  #   {
  #     from_port   = 80
  #     to_port     = 80
  #     protocol    = "tcp"
  #     cidr_blocks = ["0.0.0.0/0"]
  #   }
  # ]
  user_data = <<-EOT
              #!/bin/bash
              echo commission_white_shark > /app/app/nome-do-worker.txt
              EOT

  target_group_arns = []

  tags = {
    Environment = "prod"
    ManagedBy   = "Terraform"
  }
}

module "asg-worker-shared-migration" {
  source = "./modules/asg-launch-template"

  name              = "worker-shared-migration"
  ami               = local.shared.ami
  instance_type     = "t3a.small"
  key_name          = "4Shark-prd"
  subnet_ids        = ["subnet-043bc50dc26aeabe4", "subnet-0a2a3cf53344bb353"]
  min_size          = var.shared_migration_min_size
  max_size          = var.shared_migration_max_size
  desired_capacity  = var.shared_migration_desired_capacity

  create_security_group = false
  security_groups       = ["sg-0032e773fe9ad6125"] # Use this if not creating a new SG
  vpc_id                = "vpc-0204a1f8b5de51941"

  # sg_ingress_rules = [
  #   {
  #     from_port   = 80
  #     to_port     = 80
  #     protocol    = "tcp"
  #     cidr_blocks = ["0.0.0.0/0"]
  #   }
  # ]
  user_data = <<-EOT
              #!/bin/bash
              echo migration > /app/app/nome-do-worker.txt
              EOT

  target_group_arns = []

  tags = {
    Environment = "prod"
    ManagedBy   = "Terraform"
  }
}

module "asg-worker-shared-system" {
  source = "./modules/asg-launch-template"

  name              = "worker-shared-system"
  ami               = local.shared.ami
  instance_type     = "t3a.small"
  key_name          = "4Shark-prd"
  subnet_ids        = ["subnet-043bc50dc26aeabe4", "subnet-0a2a3cf53344bb353"]
  min_size          = var.shared_system_min_size
  max_size          = var.shared_system_max_size
  desired_capacity  = var.shared_system_desired_capacity

  create_security_group = false
  security_groups       = ["sg-0032e773fe9ad6125"] # Use this if not creating a new SG
  vpc_id                = "vpc-0204a1f8b5de51941"

  # sg_ingress_rules = [
  #   {
  #     from_port   = 80
  #     to_port     = 80
  #     protocol    = "tcp"
  #     cidr_blocks = ["0.0.0.0/0"]
  #   }
  # ]
  user_data = <<-EOT
              #!/bin/bash
              echo system > /app/app/nome-do-worker.txt
              EOT

  target_group_arns = []

  tags = {
    Environment = "prod"
    ManagedBy   = "Terraform"
  }
}

module "asg-worker-shared-user" {
  source = "./modules/asg-launch-template"

  name              = "worker-shared-user"
  ami               = local.shared.ami
  instance_type     = "t3a.small"
  key_name          = "4Shark-prd"
  subnet_ids        = ["subnet-043bc50dc26aeabe4", "subnet-0a2a3cf53344bb353"]
  min_size          = var.shared_user_min_size
  max_size          = var.shared_user_max_size
  desired_capacity  = var.shared_user_desired_capacity

  create_security_group = false
  security_groups       = ["sg-0032e773fe9ad6125"] # Use this if not creating a new SG
  vpc_id                = "vpc-0204a1f8b5de51941"

  # sg_ingress_rules = [
  #   {
  #     from_port   = 80
  #     to_port     = 80
  #     protocol    = "tcp"
  #     cidr_blocks = ["0.0.0.0/0"]
  #   }
  # ]
  user_data = <<-EOT
              #!/bin/bash
              echo user > /app/app/nome-do-worker.txt
              EOT

  target_group_arns = []

  tags = {
    Environment = "prod"
    ManagedBy   = "Terraform"
  }
}

module "asg-worker-beta-cleansing" {
  source = "./modules/asg-launch-template"

  name              = "worker-beta-cleansing"
  ami               = local.beta.ami
  instance_type     = "t3a.small"
  key_name          = "4Shark-prd"
  subnet_ids        = ["subnet-0434dbaf2d652fec7", "subnet-003ad99d0edf1b8f3"]
  min_size          = var.beta_cleansing_min_size
  max_size          = var.beta_cleansing_max_size
  desired_capacity  = var.beta_cleansing_desired_capacity

  create_security_group = false
  security_groups       = ["sg-021c3388b2d932b8e"] # Use this if not creating a new SG
  vpc_id                = "vpc-0968cc73edd5596b0"

  user_data = <<-EOT
              #!/bin/bash
              echo cleansing > /app/app/nome-do-worker.txt
              EOT

  target_group_arns = []

  tags = {
    Environment = "beta"
    ManagedBy   = "Terraform"
  }
}

module "asg-worker-beta-commission" {
  source = "./modules/asg-launch-template"

  name              = "worker-beta-commission"
  ami               = local.beta.ami
  instance_type     = "t3a.small"
  key_name          = "4Shark-prd"
  subnet_ids        = ["subnet-0434dbaf2d652fec7", "subnet-003ad99d0edf1b8f3"]
  min_size          = var.beta_commission_min_size
  max_size          = var.beta_commission_max_size
  desired_capacity  = var.beta_commission_desired_capacity

  create_security_group = false
  security_groups       = ["sg-021c3388b2d932b8e"]
  vpc_id                = "vpc-0968cc73edd5596b0"

  user_data = <<-EOT
              #!/bin/bash
              echo commission > /app/app/nome-do-worker.txt
              EOT

  target_group_arns = []

  tags = {
    Environment = "beta"
    ManagedBy   = "Terraform"
  }
}

module "asg-worker-beta-commission_tiger_shark" {
  source = "./modules/asg-launch-template"

  name              = "worker-beta-commission_tiger_shark"
  ami               = local.beta.ami
  instance_type     = "t3a.small"
  key_name          = "4Shark-prd"
  subnet_ids        = ["subnet-0434dbaf2d652fec7", "subnet-003ad99d0edf1b8f3"]
  min_size          = var.beta_commission_tiger_shark_min_size
  max_size          = var.beta_commission_tiger_shark_max_size
  desired_capacity  = var.beta_commission_tiger_shark_desired_capacity

  create_security_group = false
  security_groups       = ["sg-021c3388b2d932b8e"]
  vpc_id                = "vpc-0968cc73edd5596b0"

  user_data = <<-EOT
              #!/bin/bash
              echo commission_tiger_shark > /app/app/nome-do-worker.txt
              EOT

  target_group_arns = []

  tags = {
    Environment = "beta"
    ManagedBy   = "Terraform"
  }
}

module "asg-worker-beta-commission_white_shark" {
  source = "./modules/asg-launch-template"

  name              = "worker-beta-commission_white_shark"
  ami               = local.beta.ami
  instance_type     = "t3a.small"
  key_name          = "4Shark-prd"
  subnet_ids        = ["subnet-0434dbaf2d652fec7", "subnet-003ad99d0edf1b8f3"]
  min_size          = var.beta_commission_white_shark_min_size
  max_size          = var.beta_commission_white_shark_max_size
  desired_capacity  = var.beta_commission_white_shark_desired_capacity

  create_security_group = false
  security_groups       = ["sg-021c3388b2d932b8e"]
  vpc_id                = "vpc-0968cc73edd5596b0"

  user_data = <<-EOT
              #!/bin/bash
              echo commission_white_shark > /app/app/nome-do-worker.txt
              EOT

  target_group_arns = []

  tags = {
    Environment = "beta"
    ManagedBy   = "Terraform"
  }
}

module "asg-worker-beta-migration" {
  source = "./modules/asg-launch-template"

  name              = "worker-beta-migration"
  ami               = local.beta.ami
  instance_type     = "t3a.small"
  key_name          = "4Shark-prd"
  subnet_ids        = ["subnet-0434dbaf2d652fec7", "subnet-003ad99d0edf1b8f3"]
  min_size          = var.beta_migration_min_size
  max_size          = var.beta_migration_max_size
  desired_capacity  = var.beta_migration_desired_capacity

  create_security_group = false
  security_groups       = ["sg-021c3388b2d932b8e"]
  vpc_id                = "vpc-0968cc73edd5596b0"

  user_data = <<-EOT
              #!/bin/bash
              echo migration > /app/app/nome-do-worker.txt
              EOT

  target_group_arns = []

  tags = {
    Environment = "beta"
    ManagedBy   = "Terraform"
  }
}

module "asg-worker-beta-system" {
  source = "./modules/asg-launch-template"

  name              = "worker-beta-system"
  ami               = local.beta.ami
  instance_type     = "t3a.small"
  key_name          = "4Shark-prd"
  subnet_ids        = ["subnet-0434dbaf2d652fec7", "subnet-003ad99d0edf1b8f3"]
  min_size          = var.beta_system_min_size
  max_size          = var.beta_system_max_size
  desired_capacity  = var.beta_system_desired_capacity

  create_security_group = false
  security_groups       = ["sg-021c3388b2d932b8e"]
  vpc_id                = "vpc-0968cc73edd5596b0"

  user_data = <<-EOT
              #!/bin/bash
              echo system > /app/app/nome-do-worker.txt
              EOT

  target_group_arns = []

  tags = {
    Environment = "beta"
    ManagedBy   = "Terraform"
  }
}

module "asg-worker-beta-user" {
  source = "./modules/asg-launch-template"

  name              = "worker-beta-user"
  ami               = local.beta.ami
  instance_type     = "t3a.small"
  key_name          = "4Shark-prd"
  subnet_ids        = ["subnet-0434dbaf2d652fec7", "subnet-003ad99d0edf1b8f3"]
  min_size          = var.beta_user_min_size
  max_size          = var.beta_user_max_size
  desired_capacity  = var.beta_user_desired_capacity

  create_security_group = false
  security_groups       = ["sg-021c3388b2d932b8e"]
  vpc_id                = "vpc-0968cc73edd5596b0"

  user_data = <<-EOT
              #!/bin/bash
              echo user > /app/app/nome-do-worker.txt
              EOT

  target_group_arns = []

  tags = {
    Environment = "beta"
    ManagedBy   = "Terraform"
  }
}

module "asg-worker-demo-cleansing" {
  source = "./modules/asg-launch-template"

  name              = "worker-demo-cleansing"
  ami               = local.demo.ami
  instance_type     = "t3a.small"
  key_name          = "4Shark-prd"
  subnet_ids        = ["subnet-0a2a3cf53344bb353", "subnet-043bc50dc26aeabe4"]
  min_size          = var.demo_cleansing_min_size
  max_size          = var.demo_cleansing_max_size
  desired_capacity  = var.demo_cleansing_desired_capacity

  create_security_group = false
  security_groups       = ["sg-092d04453a53ffdf1"]
  vpc_id                = "vpc-0204a1f8b5de51941"

  user_data = <<-EOT
              #!/bin/bash
              echo cleansing > /app/app/nome-do-worker.txt
              EOT

  target_group_arns = []

  tags = {
    Environment = "demo"
    ManagedBy   = "Terraform"
  }
}

module "asg-worker-demo-commission" {
  source = "./modules/asg-launch-template"

  name              = "worker-demo-commission"
  ami               = local.demo.ami
  instance_type     = "t3a.small"
  key_name          = "4Shark-prd"
  subnet_ids        = ["subnet-0a2a3cf53344bb353", "subnet-043bc50dc26aeabe4"]
  min_size          = var.demo_commission_min_size
  max_size          = var.demo_commission_max_size
  desired_capacity  = var.demo_commission_desired_capacity

  create_security_group = false
  security_groups       = ["sg-092d04453a53ffdf1"]
  vpc_id                = "vpc-0204a1f8b5de51941"

  user_data = <<-EOT
              #!/bin/bash
              echo commission > /app/app/nome-do-worker.txt
              EOT

  target_group_arns = []

  tags = {
    Environment = "demo"
    ManagedBy   = "Terraform"
  }
}

module "asg-worker-demo-commission_tiger_shark" {
  source = "./modules/asg-launch-template"

  name              = "worker-demo-commission_tiger_shark"
  ami               = local.demo.ami
  instance_type     = "t3a.small"
  key_name          = "4Shark-prd"
  subnet_ids        = ["subnet-0a2a3cf53344bb353", "subnet-043bc50dc26aeabe4"]
  min_size          = var.demo_commission_tiger_shark_min_size
  max_size          = var.demo_commission_tiger_shark_max_size
  desired_capacity  = var.demo_commission_tiger_shark_desired_capacity


  create_security_group = false
  security_groups       = ["sg-092d04453a53ffdf1"]
  vpc_id                = "vpc-0204a1f8b5de51941"

  user_data = <<-EOT
              #!/bin/bash
              echo commission_tiger_shark > /app/app/nome-do-worker.txt
              EOT

  target_group_arns = []

  tags = {
    Environment = "demo"
    ManagedBy   = "Terraform"
  }
}

module "asg-worker-demo-commission_white_shark" {
  source = "./modules/asg-launch-template"

  name              = "worker-demo-commission_white_shark"
  ami               = local.demo.ami
  instance_type     = "t3a.small"
  key_name          = "4Shark-prd"
  subnet_ids        = ["subnet-0a2a3cf53344bb353", "subnet-043bc50dc26aeabe4"]
  min_size          = var.demo_commission_white_shark_min_size
  max_size          = var.demo_commission_white_shark_max_size
  desired_capacity  = var.demo_commission_white_shark_desired_capacity

  create_security_group = false
  security_groups       = ["sg-092d04453a53ffdf1"]
  vpc_id                = "vpc-0204a1f8b5de51941"

  user_data = <<-EOT
              #!/bin/bash
              echo commission_white_shark > /app/app/nome-do-worker.txt
              EOT

  target_group_arns = []

  tags = {
    Environment = "demo"
    ManagedBy   = "Terraform"
  }
}

module "asg-worker-demo-migration" {
  source = "./modules/asg-launch-template"

  name              = "worker-demo-migration"
  ami               = local.demo.ami
  instance_type     = "t3a.small"
  key_name          = "4Shark-prd"
  subnet_ids        = ["subnet-0a2a3cf53344bb353", "subnet-043bc50dc26aeabe4"]
  min_size          = var.demo_migration_min_size
  max_size          = var.demo_migration_max_size
  desired_capacity  = var.demo_migration_desired_capacity

  create_security_group = false
  security_groups       = ["sg-092d04453a53ffdf1"]
  vpc_id                = "vpc-0204a1f8b5de51941"

  user_data = <<-EOT
              #!/bin/bash
              echo migration > /app/app/nome-do-worker.txt
              EOT

  target_group_arns = []

  tags = {
    Environment = "demo"
    ManagedBy   = "Terraform"
  }
}

module "asg-worker-demo-system" {
  source = "./modules/asg-launch-template"

  name              = "worker-demo-system"
  ami               = local.demo.ami
  instance_type     = "t3a.small"
  key_name          = "4Shark-prd"
  subnet_ids        = ["subnet-0a2a3cf53344bb353", "subnet-043bc50dc26aeabe4"]
  min_size          = var.demo_system_min_size
  max_size          = var.demo_system_max_size
  desired_capacity  = var.demo_system_desired_capacity

  create_security_group = false
  security_groups       = ["sg-092d04453a53ffdf1"]
  vpc_id                = "vpc-0204a1f8b5de51941"

  user_data = <<-EOT
              #!/bin/bash
              echo system > /app/app/nome-do-worker.txt
              EOT

  target_group_arns = []

  tags = {
    Environment = "demo"
    ManagedBy   = "Terraform"
  }
}

module "asg-worker-demo-user" {
  source = "./modules/asg-launch-template"

  name              = "worker-demo-user"
  ami               = local.demo.ami
  instance_type     = "t3a.small"
  key_name          = "4Shark-prd"
  subnet_ids        = ["subnet-0a2a3cf53344bb353", "subnet-043bc50dc26aeabe4"]
  min_size          = var.demo_user_min_size
  max_size          = var.demo_user_max_size
  desired_capacity  = var.demo_user_desired_capacity

  create_security_group = false
  security_groups       = ["sg-092d04453a53ffdf1"]
  vpc_id                = "vpc-0204a1f8b5de51941"

  user_data = <<-EOT
              #!/bin/bash
              echo user > /app/app/nome-do-worker.txt
              EOT

  target_group_arns = []

  tags = {
    Environment = "demo"
    ManagedBy   = "Terraform"
  }
}

environment                 = "shared"
name                        = "vpc"
vpc_name                    = "Shared"
cidr_block                  = "10.10.0.0/16"
instance_tenancy            = "default"
private_subnets             = ["10.10.107.0/24", "10.10.108.0/24", "10.10.109.0/24"]
public_subnets              = ["10.10.7.0/24", "10.10.8.0/24", "10.10.9.0/24"]
igwname                     = "igw"
natname                     = "natgw"
rtname                      = "rt"
key_name                    = "4Shark-shared"
cluster_name                = "001-cluster"
instance_type               = "t3a.medium"
desired_capacity            = 9 ##Cluster
max_size                    = 15
min_size                    = 0
volume_size                 = 30
volume_type                 = "gp3"
associate_public_ip_address = false
role_name                   = "ecs_instance_role" ##IAM Role padrão do ECS
sgname                      = "ecs-sg-4shark"
ecs_instance_profile        = "ecs-instance-profile"
asg_tag                     = "ecs-4shark"
launch_template_name        = "ecs-4shark"
capacity_provider_name      = "shared-capacity-provider"
enable_managed_termination  = false
target_capacity_percent     = 100
min_step                    = 1
max_step                    = 10.000
default_weight              = 1
default_base                = 0

services = {
  "sharedapp001-service" = {
    task_family                  = "sharedapp001"
    container_name               = "shared-app001"
    image                        = "405749097490.dkr.ecr.us-east-1.amazonaws.com/app:latest"
    task_cpu                     = 2048
    task_memory                  = 2048
    container_cpu                = 0
    container_memory             = null
    container_memory_reservation = null
    container_port               = 3000
    desired_count                = 1
    env = {
      ALB_HOSTNAME    = "internal-4shark-shared-dev-app-lb-2106105836.us-east-1.elb.amazonaws.com"
      RAILS_ENV       = "development"
      SIDEKIQ_THREADS = "10"
    }

    execution_role_arn          = "arn:aws:iam::405749097490:role/ecsTaskExecutionRole"
    task_role_arn               = "arn:aws:iam::405749097490:role/ecsTaskExecutionRole"
    cloudwatch_log_group_name   = "/ecs/shared-app001"
    create_cloudwatch_log_group = false
    enable_cloudwatch_logging   = true
  }

  "worker_migration-service" = {
    task_family                  = "worker_migration"
    container_name               = "worker_migration"
    image                        = "405749097490.dkr.ecr.us-east-1.amazonaws.com/worker_migration:latest"
    task_cpu                     = 2048
    task_memory                  = 2048
    container_cpu                = 0
    container_memory             = null
    container_memory_reservation = null

    container_port = null

    desired_count = 1

    env = {
      ALB_HOSTNAME    = "internal-4shark-shared-dev-app-lb-2106105836.us-east-1.elb.amazonaws.com"
      RAILS_ENV       = "development"
      SIDEKIQ_THREADS = "10"
    }



    execution_role_arn = "arn:aws:iam::405749097490:role/ecsTaskExecutionRole"
    task_role_arn      = "arn:aws:iam::405749097490:role/ecsTaskExecutionRole"

    cloudwatch_log_group_name   = "/ecs/shared-worker_migration"
    create_cloudwatch_log_group = false
    enable_cloudwatch_logging   = true
  }

  "worker_commission-service" = {
    task_family    = "worker_commission"
    container_name = "worker_commission"
    image          = "405749097490.dkr.ecr.us-east-1.amazonaws.com/worker_commission:latest"

    task_cpu    = 2048
    task_memory = 2048

    container_cpu                = 0
    container_memory             = null
    container_memory_reservation = null

    container_port = null

    desired_count = 1

    env = {
      ALB_HOSTNAME    = "internal-4shark-shared-dev-app-lb-2106105836.us-east-1.elb.amazonaws.com"
      RAILS_ENV       = "development"
      SIDEKIQ_THREADS = "10"
    }



    execution_role_arn = "arn:aws:iam::405749097490:role/ecsTaskExecutionRole"
    task_role_arn      = "arn:aws:iam::405749097490:role/ecsTaskExecutionRole"

    cloudwatch_log_group_name   = "/ecs/shared-worker_commission"
    create_cloudwatch_log_group = false
    enable_cloudwatch_logging   = true
  }

  "worker_cleansing-service" = {
    task_family    = "worker_cleansing"
    container_name = "worker_cleansing"
    image          = "405749097490.dkr.ecr.us-east-1.amazonaws.com/worker_cleansing:latest"

    task_cpu    = 2048
    task_memory = 2048

    container_cpu                = 0
    container_memory             = null
    container_memory_reservation = null

    container_port = null

    desired_count = 1

    env = {
      ALB_HOSTNAME    = "internal-4shark-shared-dev-app-lb-2106105836.us-east-1.elb.amazonaws.com"
      RAILS_ENV       = "development"
      SIDEKIQ_THREADS = "10"
    }



    execution_role_arn = "arn:aws:iam::405749097490:role/ecsTaskExecutionRole"
    task_role_arn      = "arn:aws:iam::405749097490:role/ecsTaskExecutionRole"

    cloudwatch_log_group_name   = "/ecs/shared-worker_migration"
    create_cloudwatch_log_group = false
    enable_cloudwatch_logging   = true
  }

  "worker_commission_tiger_shark-service" = {
    task_family    = "worker_commission_tiger_shark"
    container_name = "worker_commission_white_shark"
    image          = "405749097490.dkr.ecr.us-east-1.amazonaws.com/worker_commission_tiger_shark:latest"

    task_cpu    = 2048
    task_memory = 2048

    container_cpu                = 0
    container_memory             = null
    container_memory_reservation = null

    container_port = null
    desired_count  = 1

    env = {
      ALB_HOSTNAME    = "internal-4shark-shared-dev-app-lb-2106105836.us-east-1.elb.amazonaws.com"
      RAILS_ENV       = "development"
      SIDEKIQ_THREADS = "10"
    }



    execution_role_arn = "arn:aws:iam::405749097490:role/ecsTaskExecutionRole"
    task_role_arn      = "arn:aws:iam::405749097490:role/ecsTaskExecutionRole"

    cloudwatch_log_group_name   = "/ecs/shared-worker_commission_white_shark"
    create_cloudwatch_log_group = false
    enable_cloudwatch_logging   = true
  }
  "worker_commission_white_shark-service" = {
    task_family    = "worker_commission_white_shark"
    container_name = "worker_commission_white_shark"
    image          = "405749097490.dkr.ecr.us-east-1.amazonaws.com/worker_commission_white_shark:latest"

    task_cpu    = 2048
    task_memory = 2048

    container_cpu                = 0
    container_memory             = null
    container_memory_reservation = null

    # worker não expõe porta
    container_port = null
    desired_count  = 1

    env = {
      ALB_HOSTNAME    = "internal-4shark-shared-dev-app-lb-2106105836.us-east-1.elb.amazonaws.com"
      RAILS_ENV       = "development"
      SIDEKIQ_THREADS = "10"
    }



    execution_role_arn = "arn:aws:iam::405749097490:role/ecsTaskExecutionRole"
    task_role_arn      = "arn:aws:iam::405749097490:role/ecsTaskExecutionRole"

    cloudwatch_log_group_name   = "/ecs/shared-worker_migration"
    create_cloudwatch_log_group = false
    enable_cloudwatch_logging   = true
  }

  "worker_commission_tiger_shark-service" = {
    task_family    = "worker_commission_tiger_shark"
    container_name = "worker_commission_white_shark"
    image          = "405749097490.dkr.ecr.us-east-1.amazonaws.com/worker_commission_tiger_shark"

    task_cpu    = 2048
    task_memory = 2048

    container_cpu                = 0
    container_memory             = null
    container_memory_reservation = null

    container_port = null
    desired_count  = 1

    env = {
      ALB_HOSTNAME    = "internal-4shark-shared-dev-app-lb-2106105836.us-east-1.elb.amazonaws.com"
      RAILS_ENV       = "development"
      SIDEKIQ_THREADS = "10"
    }



    execution_role_arn = "arn:aws:iam::405749097490:role/ecsTaskExecutionRole"
    task_role_arn      = "arn:aws:iam::405749097490:role/ecsTaskExecutionRole"

    cloudwatch_log_group_name   = "/ecs/shared-worker_commission_white_shark"
    create_cloudwatch_log_group = false
    enable_cloudwatch_logging   = true
  }
  "worker_system-service" = {
    task_family    = "worker_system"
    container_name = "worker_system"
    image          = "405749097490.dkr.ecr.us-east-1.amazonaws.com/worker_system:latest"

    task_cpu    = 2048
    task_memory = 2048

    container_cpu                = 0
    container_memory             = null
    container_memory_reservation = null

    container_port = 3000

    desired_count = 1

    env = {
      ALB_HOSTNAME    = "internal-4shark-shared-dev-app-lb-2106105836.us-east-1.elb.amazonaws.com"
      RAILS_ENV       = "development"
      SIDEKIQ_THREADS = "10"
    }


    execution_role_arn = "arn:aws:iam::405749097490:role/ecsTaskExecutionRole"
    task_role_arn      = "arn:aws:iam::405749097490:role/ecsTaskExecutionRole"

    cloudwatch_log_group_name   = "/ecs/shared-worker_system"
    create_cloudwatch_log_group = false
    enable_cloudwatch_logging   = true
  }
  "worker_user-service" = {
    task_family    = "worker_user"
    container_name = "worker_user"
    image          = "405749097490.dkr.ecr.us-east-1.amazonaws.com/worker_user:latest"

    task_cpu    = 2048
    task_memory = 2048

    container_cpu                = 0
    container_memory             = null
    container_memory_reservation = null

    # worker não expõe porta
    container_port = null

    # sobe apenas sob demanda
    desired_count = 1

    env = {
      ALB_HOSTNAME    = "internal-4shark-shared-dev-app-lb-2106105836.us-east-1.elb.amazonaws.com"
      RAILS_ENV       = "development"
      SIDEKIQ_THREADS = "10"
    }



    execution_role_arn = "arn:aws:iam::405749097490:role/ecsTaskExecutionRole"
    task_role_arn      = "arn:aws:iam::405749097490:role/ecsTaskExecutionRole"

    cloudwatch_log_group_name   = "/ecs/shared-worker_migration"
    create_cloudwatch_log_group = false
    enable_cloudwatch_logging   = true
  }

  "worker_commission_tiger_shark-service" = {
    task_family    = "worker_commission_tiger_shark"
    container_name = "worker_commission_white_shark"
    image          = "405749097490.dkr.ecr.us-east-1.amazonaws.com/worker_commission_tiger_shark:latest"

    task_cpu    = 2048
    task_memory = 2048

    container_cpu                = 0
    container_memory             = null
    container_memory_reservation = null

    container_port = null
    desired_count  = 1

    env = {
      ALB_HOSTNAME    = "internal-4shark-shared-dev-app-lb-2106105836.us-east-1.elb.amazonaws.com"
      RAILS_ENV       = "development"
      SIDEKIQ_THREADS = "10"
    }



    execution_role_arn = "arn:aws:iam::405749097490:role/ecsTaskExecutionRole"
    task_role_arn      = "arn:aws:iam::405749097490:role/ecsTaskExecutionRole"

    cloudwatch_log_group_name   = "/ecs/shared-worker_user"
    create_cloudwatch_log_group = false
    enable_cloudwatch_logging   = true
  }


}

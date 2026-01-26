environment                 = "demo"
name                        = "vpc"
vpc_name                    = "Demo"
cidr_block                  = "10.10.0.0/16"
instance_tenancy            = "default"
private_subnets             = ["10.10.101.0/24", "10.10.102.0/24", "10.10.103.0/24"]
public_subnets              = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
igwname                     = "igw"
natname                     = "natgw"
rtname                      = "rt"
key_name                    = "4Shark-key"
cluster_name                = "001-cluster"
instance_type               = "t3a.medium"
desired_capacity            = 12 ##Cluster
max_size                    = 16
min_size                    = 12
volume_size                 = 30
volume_type                 = "gp3"
associate_public_ip_address = false
role_name                   = "ecs_instance_role" ##IAM Role padrão do ECS
sgname                      = "ecs-sg-4shark-demo"
ecs_instance_profile        = "ecs-instance-profile"
asg_tag                     = "ecs-4shark-demo"
launch_template_name        = "ecs-4shark-demo"
capacity_provider_name      = "demo-capacity-provider"
enable_managed_termination  = false
target_capacity_percent     = 100
min_step                    = 1
max_step                    = 10.000
default_weight              = 1
default_base                = 0

private_zone_name              = "4shark.internal"
alb_name_prefix                = "demo-001-app"
alb_record_name                = "demo001.4shark.internal"
alb_ingress_cidrs              = ["10.10.0.0/16"]
service_with_alb               = "demo-001-web-service"
enable_blue_green              = true
ecs_service_bluegreen_role_arn = null

ecr_repositories = [
  "demo-001-worker-cleansing",
  "demo-001-worker-commission",
  "demo-001-worker-commission-tiger-shark",
  "demo-001-worker-commission-white-shark",
  "demo-001-worker-migration",
  "demo-001-worker-system",
  "demo-001-worker-user",
  "demo-001-web"
]

services = {
  demo-001-web-service = {
    task_family                  = "demo-001-web"
    container_name               = "demo-001-web"
    image                        = "405749097490.dkr.ecr.us-east-1.amazonaws.com/demo-001-web:latest"
    task_cpu                     = 2048
    task_memory                  = 2048
    container_cpu                = 0
    container_memory             = null
    container_memory_reservation = null
    container_port               = 3000
    desired_count                = 1
    deployment_strategy          = "BLUE_GREEN"
    bake_time_in_minutes         = 15

    execution_role_arn          = "arn:aws:iam::405749097490:role/ecsTaskExecutionRole"
    task_role_arn               = "arn:aws:iam::405749097490:role/ecsTaskExecutionRole"
    cloudwatch_log_group_name   = "/ecs/demo-001-web"
    create_cloudwatch_log_group = true
    enable_cloudwatch_logging   = true
  }

  demo-001-worker-migration-service = {
    task_family                  = "demo-001-worker-migration"
    container_name               = "demo-001-worker-migration"
    image                        = "405749097490.dkr.ecr.us-east-1.amazonaws.com/demo-001-worker-migration:latest"
    task_cpu                     = 2048
    task_memory                  = 2048
    container_cpu                = 0
    container_memory             = null
    container_memory_reservation = null
    container_port               = null
    desired_count                = 1


    execution_role_arn = "arn:aws:iam::405749097490:role/ecsTaskExecutionRole"
    task_role_arn      = "arn:aws:iam::405749097490:role/ecsTaskExecutionRole"

    cloudwatch_log_group_name   = "/ecs/demo-001-worker-migration"
    create_cloudwatch_log_group = true
    enable_cloudwatch_logging   = true
  }

  "demo-001-worker-commission-service" = {
    task_family                  = "demo-001-worker-commission"
    container_name               = "demo-001-worker-commission"
    image                        = "405749097490.dkr.ecr.us-east-1.amazonaws.com/demo-001-worker-commission:latest"
    task_cpu                     = 2048
    task_memory                  = 2048
    container_cpu                = 0
    container_memory             = null
    container_memory_reservation = null
    container_port               = null
    desired_count                = 1

    execution_role_arn = "arn:aws:iam::405749097490:role/ecsTaskExecutionRole"
    task_role_arn      = "arn:aws:iam::405749097490:role/ecsTaskExecutionRole"

    cloudwatch_log_group_name   = "/ecs/demo-001-worker-commission"
    create_cloudwatch_log_group = true
    enable_cloudwatch_logging   = true
  }

  "demo-001-worker-cleansing-service" = {
    task_family                  = "demo-001-worker-cleansing"
    container_name               = "demo-001-worker-cleansing"
    image                        = "405749097490.dkr.ecr.us-east-1.amazonaws.com/demo-001-worker-cleansing:latest"
    task_cpu                     = 2048
    task_memory                  = 2048
    container_cpu                = 0
    container_memory             = null
    container_memory_reservation = null
    container_port               = null
    desired_count                = 1

    execution_role_arn = "arn:aws:iam::405749097490:role/ecsTaskExecutionRole"
    task_role_arn      = "arn:aws:iam::405749097490:role/ecsTaskExecutionRole"

    cloudwatch_log_group_name   = "/ecs/demo_001_worker_cleansing"
    create_cloudwatch_log_group = true
    enable_cloudwatch_logging   = true
  }

  "demo-001-worker-commission-tiger-shark-service" = {
    task_family                  = "demo-001-worker-commission-tiger-shark"
    container_name               = "demo-001-worker-commission-tiger-shark"
    image                        = "405749097490.dkr.ecr.us-east-1.amazonaws.com/demo-001-worker-commission-tiger-shark:latest"
    task_cpu                     = 2048
    task_memory                  = 2048
    container_cpu                = 0
    container_memory             = null
    container_memory_reservation = null
    container_port               = null
    desired_count                = 1


    execution_role_arn = "arn:aws:iam::405749097490:role/ecsTaskExecutionRole"
    task_role_arn      = "arn:aws:iam::405749097490:role/ecsTaskExecutionRole"

    cloudwatch_log_group_name   = "/ecs/demo-001-worker-commission-tiger-shark"
    create_cloudwatch_log_group = true
    enable_cloudwatch_logging   = true
  }

  "demo-001-worker-commission-white-shark-service" = {
    task_family                  = "demo-001-worker-commission-white-shark"
    container_name               = "demo-001-worker-commission-white-shark"
    image                        = "405749097490.dkr.ecr.us-east-1.amazonaws.com/demo-001-worker-commission-white-shark:latest"
    task_cpu                     = 2048
    task_memory                  = 2048
    container_cpu                = 0
    container_memory             = null
    container_memory_reservation = null
    container_port               = null
    desired_count                = 1


    execution_role_arn = "arn:aws:iam::405749097490:role/ecsTaskExecutionRole"
    task_role_arn      = "arn:aws:iam::405749097490:role/ecsTaskExecutionRole"

    cloudwatch_log_group_name   = "/ecs/demo-001-worker-commission-white-shark"
    create_cloudwatch_log_group = true
    enable_cloudwatch_logging   = true
  }

  "demo-001-worker-system-service" = {
    task_family                  = "demo-001-worker-system"
    container_name               = "demo-001-worker-system"
    image                        = "405749097490.dkr.ecr.us-east-1.amazonaws.com/demo-001-worker-system:latest"
    task_cpu                     = 2048
    task_memory                  = 2048
    container_cpu                = 0
    container_memory             = null
    container_memory_reservation = null
    container_port               = 3000
    desired_count                = 1


    execution_role_arn = "arn:aws:iam::405749097490:role/ecsTaskExecutionRole"
    task_role_arn      = "arn:aws:iam::405749097490:role/ecsTaskExecutionRole"

    cloudwatch_log_group_name   = "/ecs/demo-001-worker-system"
    create_cloudwatch_log_group = true
    enable_cloudwatch_logging   = true
  }

  "demo-001-worker-user-service" = {
    task_family                  = "demo-001-worker-user"
    container_name               = "demo-001-worker-user"
    image                        = "405749097490.dkr.ecr.us-east-1.amazonaws.com/demo-001-worker-user:latest"
    task_cpu                     = 2048
    task_memory                  = 2048
    container_cpu                = 0
    container_memory             = null
    container_memory_reservation = null
    container_port               = null
    desired_count                = 1


    execution_role_arn = "arn:aws:iam::405749097490:role/ecsTaskExecutionRole"
    task_role_arn      = "arn:aws:iam::405749097490:role/ecsTaskExecutionRole"

    cloudwatch_log_group_name   = "/ecs/demo-001-worker-user"
    create_cloudwatch_log_group = true
    enable_cloudwatch_logging   = true
  }

}

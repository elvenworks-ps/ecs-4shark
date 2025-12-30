environment                 = "beta"
name                        = "vpc"
vpc_name                    = "Beta"
cidr_block                  = "10.10.0.0/16"
instance_tenancy            = "default"
private_subnets             = ["10.10.101.0/24", "10.10.102.0/24", "10.10.103.0/24"]
public_subnets              = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
igwname                     = "igw"
natname                     = "natgw"
rtname                      = "rt"
key_name                    = "4Shark-beta"
cluster_name                = "001-cluster"
instance_type               = "t3a.medium"
desired_capacity            = 4 ##Cluster
max_size                    = 10
min_size                    = 0
volume_size                 = 30
volume_type                 = "gp3"
associate_public_ip_address = false
role_name                   = "ecs_instance_role" ##IAM Role padrão do ECS
sgname                      = "ecs-sg-4shark"
ecs_instance_profile        = "ecs-instance-profile"
asg_tag                     = "ecs-4shark"
launch_template_name        = "ecs-4shark"
capacity_provider_name      = "beta-capacity-provider"
enable_managed_termination  = false
target_capacity_percent     = 100
min_step                    = 1
max_step                    = 10.000
default_weight              = 1
default_base                = 0

services = {
  "betaapp001-service" = {
    task_family                  = "betaapp001"
    container_name               = "beta-app001"
    image                        = "405749097490.dkr.ecr.us-east-1.amazonaws.com/beta-app:latest"
    task_cpu                     = 2048
    task_memory                  = 2048
    container_cpu                = 0
    container_memory             = null
    container_memory_reservation = null
    container_port               = 3000
    desired_count                = 1
    env = {
      ALB_HOSTNAME    = "internal-4shark-beta-dev-app-lb-2106105836.us-east-1.elb.amazonaws.com"
      RAILS_ENV       = "development"
      SIDEKIQ_THREADS = "10"
    }
    secrets = [
      { name = "DIFFEND_PROJECT_ID", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:DIFFEND_PROJECT_ID::" },
      { name = "DIFFEND_SHAREABLE_ID", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:DIFFEND_SHAREABLE_ID::" },
      { name = "DIFFEND_SHAREABLE_KEY", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:DIFFEND_SHAREABLE_KEY::" },
      { name = "MONGO_CLUSTER", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:MONGO_CLUSTER::" },
      { name = "MONGO_CONNECT_TIMEOUT", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:MONGO_CONNECT_TIMEOUT::" },
      { name = "MONGO_MONITORING_IO", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:MONGO_MONITORING_IO::" },
      { name = "MONGO_SERVER_SELECTION_TIMEOUT", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:MONGO_SERVER_SELECTION_TIMEOUT::" },
      { name = "MONGO_SOCKET_TIMEOUT", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:MONGO_SOCKET_TIMEOUT::" },
      { name = "MONGO_URL", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:MONGO_URL::" },
      { name = "REDIS_URL", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:REDIS_URL::" },
      { name = "SECRET_KEY_BASE", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:SECRET_KEY_BASE::" },
      { name = "USER_ANONYMIZING_WINDOW", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:USER_ANONYMIZING_WINDOW::" },
      { name = "WEB_CONCURRENCY", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:WEB_CONCURRENCY::" },
      { name = "WEB_MAX_THREADS", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:WEB_MAX_THREADS::" },
      { name = "ROLLBAR_SERVER_ACCESS_TOKEN", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:ROLLBAR_SERVER_ACCESS_TOKEN::" },
      { name = "ROLLBAR_CLIENT_ACCESS_TOKEN", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:ROLLBAR_CLIENT_ACCESS_TOKEN::" },
      { name = "RAILS_SERVE_STATIC_FILES", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:RAILS_SERVE_STATIC_FILES::" },
      { name = "RAILS_PG_EXTRAS_PUBLIC_DASHBOARD", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:RAILS_PG_EXTRAS_PUBLIC_DASHBOARD::" },
      { name = "RAILS_MASTER_KEY", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:RAILS_MASTER_KEY::" },
      { name = "RAILS_LOG_TO_STDOUT", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:RAILS_LOG_TO_STDOUT::" },
      { name = "RACK_TIMEOUT_WAIT_TIMEOUT", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:RACK_TIMEOUT_WAIT_TIMEOUT::" },
      { name = "RACK_TIMEOUT_WAIT_OVERTIME", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:RACK_TIMEOUT_WAIT_OVERTIME::" },
      { name = "RACK_TIMEOUT_SERVICE_TIMEOUT", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:RACK_TIMEOUT_SERVICE_TIMEOUT::" },
      { name = "RACK_ENV", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:RACK_ENV::" },
      { name = "PG_STATEMENT_TIMEOUT", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:PG_STATEMENT_TIMEOUT::" },
      { name = "PG_CHECKOUT_TIMEOUT", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:PG_CHECKOUT_TIMEOUT::" },
      { name = "PG_CONNECT_TIMEOUT", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:PG_CONNECT_TIMEOUT::" },
      { name = "PGBOUNCER_PREPARED_STATEMENTS", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:PGBOUNCER_PREPARED_STATEMENTS::" },
      { name = "NEW_RELIC_LICENSE_KEY", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:NEW_RELIC_LICENSE_KEY::" },
      { name = "NEW_RELIC_APP_NAME", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:NEW_RELIC_APP_NAME::" },
      { name = "NEW_RELIC_AGENT_ENABLED", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:NEW_RELIC_AGENT_ENABLED::" },
      { name = "LANG", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:LANG::" },
      { name = "HIREFIRE_TOKEN", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:HIREFIRE_TOKEN::" },
      { name = "ENVIRONMENT", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:ENVIRONMENT::" },
      { name = "DOMAIN", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:DOMAIN::" },
      { name = "DISABLE_DATADOG_AGENT", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:DISABLE_DATADOG_AGENT::" },
      { name = "DD_TRACE_ANALYTICS_ENABLED", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:DD_TRACE_ANALYTICS_ENABLED::" },
      { name = "DD_PROCESS_AGENT", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:DD_PROCESS_AGENT::" },
      { name = "DD_LOG_TO_CONSOLE", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:DD_LOG_TO_CONSOLE::" },
      { name = "DD_LOGS_ENABLED", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:DD_LOGS_ENABLED::" },
      { name = "DD_DYNO_HOST", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:DD_DYNO_HOST::" },
      { name = "DD_DISABLE_HOST_METRICS", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:DD_DISABLE_HOST_METRICS::" },
      { name = "DD_APM_ENABLED", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:DD_APM_ENABLED::" },
      { name = "DD_API_KEY", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:DD_API_KEY::" },
      { name = "DATA_DOG_APPLICATION_KEY", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:DATA_DOG_APPLICATION_KEY::" },
      { name = "DATA_DOG_API_KEY", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:DATA_DOG_API_KEY::" },
      { name = "DATABASE_URL_DEPRECATED", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:DATABASE_URL_DEPRECATED::" },
      { name = "CURRENCY_API_KEY", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:CURRENCY_API_KEY::" },
      { name = "CORS_ORIGINS", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:CORS_ORIGINS::" },
      { name = "COMPANY_ANONYMIZING_WINDOW", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:COMPANY_ANONYMIZING_WINDOW::" },
      { name = "BUNDLE_WITHOUT", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:BUNDLE_WITHOUT::" },
      { name = "AWS_BUCKET", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:AWS_BUCKET::" },
      { name = "PATH", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:PATH::" },
      { name = "PG_PRIMARY_URL", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:PG_PRIMARY_URL::" },
      { name = "DATABASE_URL", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta_database-GPdRwb:DATABASE_URL::" },
      { name = "AWS_ACCESS_KEY_ID", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:AWS_ACCESS_KEY_ID::" },
      { name = "AWS_S3_REGION", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:AWS_S3_REGION::" },
      { name = "AWS_SECRET_ACCESS_KEY", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:AWS_SECRET_ACCESS_KEY::" },
      { name = "ENABLE_DEVELOPMENT_APP_COR", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:ENABLE_DEVELOPMENT_APP_COR::" }
    ]
    execution_role_arn          = "arn:aws:iam::405749097490:role/ecsTaskExecutionRole"
    task_role_arn               = "arn:aws:iam::405749097490:role/ecsTaskExecutionRole"
    cloudwatch_log_group_name   = "/ecs/betaapp001"
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
      ALB_HOSTNAME    = "internal-4shark-beta-dev-app-lb-2106105836.us-east-1.elb.amazonaws.com"
      RAILS_ENV       = "development"
      SIDEKIQ_THREADS = "10"
    }

    secrets = [
      { name = "DIFFEND_PROJECT_ID", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:DIFFEND_PROJECT_ID::" },
      { name = "DIFFEND_SHAREABLE_ID", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:DIFFEND_SHAREABLE_ID::" },
      { name = "DIFFEND_SHAREABLE_KEY", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:DIFFEND_SHAREABLE_KEY::" },
      { name = "MONGO_CLUSTER", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:MONGO_CLUSTER::" },
      { name = "MONGO_CONNECT_TIMEOUT", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:MONGO_CONNECT_TIMEOUT::" },
      { name = "MONGO_MONITORING_IO", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:MONGO_MONITORING_IO::" },
      { name = "MONGO_SERVER_SELECTION_TIMEOUT", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:MONGO_SERVER_SELECTION_TIMEOUT::" },
      { name = "MONGO_SOCKET_TIMEOUT", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:MONGO_SOCKET_TIMEOUT::" },
      { name = "MONGO_URL", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:MONGO_URL::" },
      { name = "REDIS_URL", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:REDIS_URL::" },
      { name = "SECRET_KEY_BASE", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:SECRET_KEY_BASE::" },
      { name = "USER_ANONYMIZING_WINDOW", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:USER_ANONYMIZING_WINDOW::" },
      { name = "WEB_CONCURRENCY", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:WEB_CONCURRENCY::" },
      { name = "WEB_MAX_THREADS", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:WEB_MAX_THREADS::" },
      { name = "ROLLBAR_SERVER_ACCESS_TOKEN", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:ROLLBAR_SERVER_ACCESS_TOKEN::" },
      { name = "ROLLBAR_CLIENT_ACCESS_TOKEN", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:ROLLBAR_CLIENT_ACCESS_TOKEN::" },
      { name = "RAILS_SERVE_STATIC_FILES", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:RAILS_SERVE_STATIC_FILES::" },
      { name = "RAILS_PG_EXTRAS_PUBLIC_DASHBOARD", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:RAILS_PG_EXTRAS_PUBLIC_DASHBOARD::" },
      { name = "RAILS_MASTER_KEY", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:RAILS_MASTER_KEY::" },
      { name = "RAILS_LOG_TO_STDOUT", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:RAILS_LOG_TO_STDOUT::" },
      { name = "RACK_TIMEOUT_WAIT_TIMEOUT", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:RACK_TIMEOUT_WAIT_TIMEOUT::" },
      { name = "RACK_TIMEOUT_WAIT_OVERTIME", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:RACK_TIMEOUT_WAIT_OVERTIME::" },
      { name = "RACK_TIMEOUT_SERVICE_TIMEOUT", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:RACK_TIMEOUT_SERVICE_TIMEOUT::" },
      { name = "RACK_ENV", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:RACK_ENV::" },
      { name = "PG_STATEMENT_TIMEOUT", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:PG_STATEMENT_TIMEOUT::" },
      { name = "PG_CHECKOUT_TIMEOUT", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:PG_CHECKOUT_TIMEOUT::" },
      { name = "PG_CONNECT_TIMEOUT", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:PG_CONNECT_TIMEOUT::" },
      { name = "PGBOUNCER_PREPARED_STATEMENTS", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:PGBOUNCER_PREPARED_STATEMENTS::" },
      { name = "NEW_RELIC_LICENSE_KEY", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:NEW_RELIC_LICENSE_KEY::" },
      { name = "NEW_RELIC_APP_NAME", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:NEW_RELIC_APP_NAME::" },
      { name = "NEW_RELIC_AGENT_ENABLED", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:NEW_RELIC_AGENT_ENABLED::" },
      { name = "LANG", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:LANG::" },
      { name = "HIREFIRE_TOKEN", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:HIREFIRE_TOKEN::" },
      { name = "ENVIRONMENT", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:ENVIRONMENT::" },
      { name = "DOMAIN", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:DOMAIN::" },
      { name = "DISABLE_DATADOG_AGENT", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:DISABLE_DATADOG_AGENT::" },
      { name = "DD_TRACE_ANALYTICS_ENABLED", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:DD_TRACE_ANALYTICS_ENABLED::" },
      { name = "DD_PROCESS_AGENT", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:DD_PROCESS_AGENT::" },
      { name = "DD_LOG_TO_CONSOLE", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:DD_LOG_TO_CONSOLE::" },
      { name = "DD_LOGS_ENABLED", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:DD_LOGS_ENABLED::" },
      { name = "DD_DYNO_HOST", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:DD_DYNO_HOST::" },
      { name = "DD_DISABLE_HOST_METRICS", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:DD_DISABLE_HOST_METRICS::" },
      { name = "DD_APM_ENABLED", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:DD_APM_ENABLED::" },
      { name = "DD_API_KEY", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:DD_API_KEY::" },
      { name = "DATA_DOG_APPLICATION_KEY", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:DATA_DOG_APPLICATION_KEY::" },
      { name = "DATA_DOG_API_KEY", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:DATA_DOG_API_KEY::" },
      { name = "DATABASE_URL_DEPRECATED", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:DATABASE_URL_DEPRECATED::" },
      { name = "CURRENCY_API_KEY", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:CURRENCY_API_KEY::" },
      { name = "CORS_ORIGINS", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:CORS_ORIGINS::" },
      { name = "COMPANY_ANONYMIZING_WINDOW", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:COMPANY_ANONYMIZING_WINDOW::" },
      { name = "BUNDLE_WITHOUT", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:BUNDLE_WITHOUT::" },
      { name = "AWS_BUCKET", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:AWS_BUCKET::" },
      { name = "PATH", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:PATH::" },
      { name = "PG_PRIMARY_URL", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:PG_PRIMARY_URL::" },
      { name = "DATABASE_URL", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta_database-GPdRwb:DATABASE_URL::" },
      { name = "AWS_ACCESS_KEY_ID", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:AWS_ACCESS_KEY_ID::" },
      { name = "AWS_S3_REGION", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:AWS_S3_REGION::" },
      { name = "AWS_SECRET_ACCESS_KEY", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:AWS_SECRET_ACCESS_KEY::" },
      { name = "ENABLE_DEVELOPMENT_APP_COR", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:ENABLE_DEVELOPMENT_APP_COR::" }
    ]

    execution_role_arn = "arn:aws:iam::405749097490:role/ecsTaskExecutionRole"
    task_role_arn      = "arn:aws:iam::405749097490:role/ecsTaskExecutionRole"

    cloudwatch_log_group_name   = "/ecs/beta-worker_migration"
    create_cloudwatch_log_group = true
    enable_cloudwatch_logging   = true
  }

  "worker-commission-service" = {
    task_family    = "worker-commission"
    container_name = "worker-commission"
    image          = "405749097490.dkr.ecr.us-east-1.amazonaws.com/worker-commission:latest"

    task_cpu    = 2048
    task_memory = 2048

    container_cpu                = 0
    container_memory             = null
    container_memory_reservation = null

    container_port = null

    desired_count = 1

    env = {
      ALB_HOSTNAME    = "internal-4shark-beta-dev-app-lb-2106105836.us-east-1.elb.amazonaws.com"
      RAILS_ENV       = "development"
      SIDEKIQ_THREADS = "10"
    }

    secrets = [
      { name = "DIFFEND_PROJECT_ID", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:DIFFEND_PROJECT_ID::" },
      { name = "DIFFEND_SHAREABLE_ID", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:DIFFEND_SHAREABLE_ID::" },
      { name = "DIFFEND_SHAREABLE_KEY", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:DIFFEND_SHAREABLE_KEY::" },
      { name = "MONGO_CLUSTER", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:MONGO_CLUSTER::" },
      { name = "MONGO_CONNECT_TIMEOUT", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:MONGO_CONNECT_TIMEOUT::" },
      { name = "MONGO_MONITORING_IO", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:MONGO_MONITORING_IO::" },
      { name = "MONGO_SERVER_SELECTION_TIMEOUT", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:MONGO_SERVER_SELECTION_TIMEOUT::" },
      { name = "MONGO_SOCKET_TIMEOUT", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:MONGO_SOCKET_TIMEOUT::" },
      { name = "MONGO_URL", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:MONGO_URL::" },
      { name = "REDIS_URL", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:REDIS_URL::" },
      { name = "SECRET_KEY_BASE", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:SECRET_KEY_BASE::" },
      { name = "USER_ANONYMIZING_WINDOW", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:USER_ANONYMIZING_WINDOW::" },
      { name = "WEB_CONCURRENCY", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:WEB_CONCURRENCY::" },
      { name = "WEB_MAX_THREADS", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:WEB_MAX_THREADS::" },
      { name = "ROLLBAR_SERVER_ACCESS_TOKEN", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:ROLLBAR_SERVER_ACCESS_TOKEN::" },
      { name = "ROLLBAR_CLIENT_ACCESS_TOKEN", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:ROLLBAR_CLIENT_ACCESS_TOKEN::" },
      { name = "RAILS_SERVE_STATIC_FILES", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:RAILS_SERVE_STATIC_FILES::" },
      { name = "RAILS_PG_EXTRAS_PUBLIC_DASHBOARD", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:RAILS_PG_EXTRAS_PUBLIC_DASHBOARD::" },
      { name = "RAILS_MASTER_KEY", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:RAILS_MASTER_KEY::" },
      { name = "RAILS_LOG_TO_STDOUT", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:RAILS_LOG_TO_STDOUT::" },
      { name = "RACK_TIMEOUT_WAIT_TIMEOUT", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:RACK_TIMEOUT_WAIT_TIMEOUT::" },
      { name = "RACK_TIMEOUT_WAIT_OVERTIME", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:RACK_TIMEOUT_WAIT_OVERTIME::" },
      { name = "RACK_TIMEOUT_SERVICE_TIMEOUT", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:RACK_TIMEOUT_SERVICE_TIMEOUT::" },
      { name = "RACK_ENV", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:RACK_ENV::" },
      { name = "PG_STATEMENT_TIMEOUT", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:PG_STATEMENT_TIMEOUT::" },
      { name = "PG_CHECKOUT_TIMEOUT", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:PG_CHECKOUT_TIMEOUT::" },
      { name = "PG_CONNECT_TIMEOUT", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:PG_CONNECT_TIMEOUT::" },
      { name = "PGBOUNCER_PREPARED_STATEMENTS", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:PGBOUNCER_PREPARED_STATEMENTS::" },
      { name = "NEW_RELIC_LICENSE_KEY", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:NEW_RELIC_LICENSE_KEY::" },
      { name = "NEW_RELIC_APP_NAME", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:NEW_RELIC_APP_NAME::" },
      { name = "NEW_RELIC_AGENT_ENABLED", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:NEW_RELIC_AGENT_ENABLED::" },
      { name = "LANG", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:LANG::" },
      { name = "HIREFIRE_TOKEN", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:HIREFIRE_TOKEN::" },
      { name = "ENVIRONMENT", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:ENVIRONMENT::" },
      { name = "DOMAIN", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:DOMAIN::" },
      { name = "DISABLE_DATADOG_AGENT", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:DISABLE_DATADOG_AGENT::" },
      { name = "DD_TRACE_ANALYTICS_ENABLED", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:DD_TRACE_ANALYTICS_ENABLED::" },
      { name = "DD_PROCESS_AGENT", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:DD_PROCESS_AGENT::" },
      { name = "DD_LOG_TO_CONSOLE", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:DD_LOG_TO_CONSOLE::" },
      { name = "DD_LOGS_ENABLED", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:DD_LOGS_ENABLED::" },
      { name = "DD_DYNO_HOST", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:DD_DYNO_HOST::" },
      { name = "DD_DISABLE_HOST_METRICS", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:DD_DISABLE_HOST_METRICS::" },
      { name = "DD_APM_ENABLED", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:DD_APM_ENABLED::" },
      { name = "DD_API_KEY", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:DD_API_KEY::" },
      { name = "DATA_DOG_APPLICATION_KEY", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:DATA_DOG_APPLICATION_KEY::" },
      { name = "DATA_DOG_API_KEY", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:DATA_DOG_API_KEY::" },
      { name = "DATABASE_URL_DEPRECATED", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:DATABASE_URL_DEPRECATED::" },
      { name = "CURRENCY_API_KEY", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:CURRENCY_API_KEY::" },
      { name = "CORS_ORIGINS", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:CORS_ORIGINS::" },
      { name = "COMPANY_ANONYMIZING_WINDOW", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:COMPANY_ANONYMIZING_WINDOW::" },
      { name = "BUNDLE_WITHOUT", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:BUNDLE_WITHOUT::" },
      { name = "AWS_BUCKET", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:AWS_BUCKET::" },
      { name = "PATH", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:PATH::" },
      { name = "PG_PRIMARY_URL", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:PG_PRIMARY_URL::" },
      { name = "DATABASE_URL", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta_database-GPdRwb:DATABASE_URL::" },
      { name = "AWS_ACCESS_KEY_ID", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:AWS_ACCESS_KEY_ID::" },
      { name = "AWS_S3_REGION", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:AWS_S3_REGION::" },
      { name = "AWS_SECRET_ACCESS_KEY", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:AWS_SECRET_ACCESS_KEY::" },
      { name = "ENABLE_DEVELOPMENT_APP_COR", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:ENABLE_DEVELOPMENT_APP_COR::" }
    ]

    execution_role_arn = "arn:aws:iam::405749097490:role/ecsTaskExecutionRole"
    task_role_arn      = "arn:aws:iam::405749097490:role/ecsTaskExecutionRole"

    cloudwatch_log_group_name   = "/ecs/beta-worker-commission"
    create_cloudwatch_log_group = true
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
      ALB_HOSTNAME    = "internal-4shark-beta-dev-app-lb-2106105836.us-east-1.elb.amazonaws.com"
      RAILS_ENV       = "development"
      SIDEKIQ_THREADS = "10"
    }

    secrets = [
      { name = "DIFFEND_PROJECT_ID", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:DIFFEND_PROJECT_ID::" },
      { name = "DIFFEND_SHAREABLE_ID", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:DIFFEND_SHAREABLE_ID::" },
      { name = "DIFFEND_SHAREABLE_KEY", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:DIFFEND_SHAREABLE_KEY::" },
      { name = "MONGO_CLUSTER", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:MONGO_CLUSTER::" },
      { name = "MONGO_CONNECT_TIMEOUT", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:MONGO_CONNECT_TIMEOUT::" },
      { name = "MONGO_MONITORING_IO", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:MONGO_MONITORING_IO::" },
      { name = "MONGO_SERVER_SELECTION_TIMEOUT", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:MONGO_SERVER_SELECTION_TIMEOUT::" },
      { name = "MONGO_SOCKET_TIMEOUT", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:MONGO_SOCKET_TIMEOUT::" },
      { name = "MONGO_URL", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:MONGO_URL::" },
      { name = "REDIS_URL", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:REDIS_URL::" },
      { name = "SECRET_KEY_BASE", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:SECRET_KEY_BASE::" },
      { name = "USER_ANONYMIZING_WINDOW", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:USER_ANONYMIZING_WINDOW::" },
      { name = "WEB_CONCURRENCY", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:WEB_CONCURRENCY::" },
      { name = "WEB_MAX_THREADS", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:WEB_MAX_THREADS::" },
      { name = "ROLLBAR_SERVER_ACCESS_TOKEN", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:ROLLBAR_SERVER_ACCESS_TOKEN::" },
      { name = "ROLLBAR_CLIENT_ACCESS_TOKEN", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:ROLLBAR_CLIENT_ACCESS_TOKEN::" },
      { name = "RAILS_SERVE_STATIC_FILES", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:RAILS_SERVE_STATIC_FILES::" },
      { name = "RAILS_PG_EXTRAS_PUBLIC_DASHBOARD", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:RAILS_PG_EXTRAS_PUBLIC_DASHBOARD::" },
      { name = "RAILS_MASTER_KEY", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:RAILS_MASTER_KEY::" },
      { name = "RAILS_LOG_TO_STDOUT", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:RAILS_LOG_TO_STDOUT::" },
      { name = "RACK_TIMEOUT_WAIT_TIMEOUT", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:RACK_TIMEOUT_WAIT_TIMEOUT::" },
      { name = "RACK_TIMEOUT_WAIT_OVERTIME", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:RACK_TIMEOUT_WAIT_OVERTIME::" },
      { name = "RACK_TIMEOUT_SERVICE_TIMEOUT", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:RACK_TIMEOUT_SERVICE_TIMEOUT::" },
      { name = "RACK_ENV", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:RACK_ENV::" },
      { name = "PG_STATEMENT_TIMEOUT", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:PG_STATEMENT_TIMEOUT::" },
      { name = "PG_CHECKOUT_TIMEOUT", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:PG_CHECKOUT_TIMEOUT::" },
      { name = "PG_CONNECT_TIMEOUT", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:PG_CONNECT_TIMEOUT::" },
      { name = "PGBOUNCER_PREPARED_STATEMENTS", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:PGBOUNCER_PREPARED_STATEMENTS::" },
      { name = "NEW_RELIC_LICENSE_KEY", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:NEW_RELIC_LICENSE_KEY::" },
      { name = "NEW_RELIC_APP_NAME", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:NEW_RELIC_APP_NAME::" },
      { name = "NEW_RELIC_AGENT_ENABLED", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:NEW_RELIC_AGENT_ENABLED::" },
      { name = "LANG", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:LANG::" },
      { name = "HIREFIRE_TOKEN", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:HIREFIRE_TOKEN::" },
      { name = "ENVIRONMENT", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:ENVIRONMENT::" },
      { name = "DOMAIN", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:DOMAIN::" },
      { name = "DISABLE_DATADOG_AGENT", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:DISABLE_DATADOG_AGENT::" },
      { name = "DD_TRACE_ANALYTICS_ENABLED", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:DD_TRACE_ANALYTICS_ENABLED::" },
      { name = "DD_PROCESS_AGENT", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:DD_PROCESS_AGENT::" },
      { name = "DD_LOG_TO_CONSOLE", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:DD_LOG_TO_CONSOLE::" },
      { name = "DD_LOGS_ENABLED", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:DD_LOGS_ENABLED::" },
      { name = "DD_DYNO_HOST", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:DD_DYNO_HOST::" },
      { name = "DD_DISABLE_HOST_METRICS", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:DD_DISABLE_HOST_METRICS::" },
      { name = "DD_APM_ENABLED", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:DD_APM_ENABLED::" },
      { name = "DD_API_KEY", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:DD_API_KEY::" },
      { name = "DATA_DOG_APPLICATION_KEY", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:DATA_DOG_APPLICATION_KEY::" },
      { name = "DATA_DOG_API_KEY", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:DATA_DOG_API_KEY::" },
      { name = "DATABASE_URL_DEPRECATED", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:DATABASE_URL_DEPRECATED::" },
      { name = "CURRENCY_API_KEY", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:CURRENCY_API_KEY::" },
      { name = "CORS_ORIGINS", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:CORS_ORIGINS::" },
      { name = "COMPANY_ANONYMIZING_WINDOW", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:COMPANY_ANONYMIZING_WINDOW::" },
      { name = "BUNDLE_WITHOUT", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:BUNDLE_WITHOUT::" },
      { name = "AWS_BUCKET", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:AWS_BUCKET::" },
      { name = "PATH", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:PATH::" },
      { name = "PG_PRIMARY_URL", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:PG_PRIMARY_URL::" },
      { name = "DATABASE_URL", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta_database-GPdRwb:DATABASE_URL::" },
      { name = "AWS_ACCESS_KEY_ID", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:AWS_ACCESS_KEY_ID::" },
      { name = "AWS_S3_REGION", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:AWS_S3_REGION::" },
      { name = "AWS_SECRET_ACCESS_KEY", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:AWS_SECRET_ACCESS_KEY::" },
      { name = "ENABLE_DEVELOPMENT_APP_COR", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:ENABLE_DEVELOPMENT_APP_COR::" }
    ]

    execution_role_arn = "arn:aws:iam::405749097490:role/ecsTaskExecutionRole"
    task_role_arn      = "arn:aws:iam::405749097490:role/ecsTaskExecutionRole"

    cloudwatch_log_group_name   = "/ecs/betaworker_migration"
    create_cloudwatch_log_group = true
    enable_cloudwatch_logging   = true
  }

  "worker_commission_tiger_shark-service" = {
    task_family    = "worker_commission_tiger_shark"
    container_name = "worker_commission_white_shark"
    image          = "405749097490.dkr.ecr.us-east-1:405749097490.dkr.ecr.us-east-1.amazonaws.com/worker_commission_tiger_shark:latest"

    task_cpu    = 2048
    task_memory = 2048

    container_cpu                = 0
    container_memory             = null
    container_memory_reservation = null

    container_port = null
    desired_count  = 1

    env = {
      ALB_HOSTNAME    = "internal-4shark-beta-dev-app-lb-2106105836.us-east-1.elb.amazonaws.com"
      RAILS_ENV       = "development"
      SIDEKIQ_THREADS = "10"
    }

    secrets = [
      { name = "DIFFEND_PROJECT_ID", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:DIFFEND_PROJECT_ID::" },
      { name = "DIFFEND_SHAREABLE_ID", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:DIFFEND_SHAREABLE_ID::" },
      { name = "DIFFEND_SHAREABLE_KEY", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:DIFFEND_SHAREABLE_KEY::" },
      { name = "MONGO_CLUSTER", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:MONGO_CLUSTER::" },
      { name = "MONGO_CONNECT_TIMEOUT", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:MONGO_CONNECT_TIMEOUT::" },
      { name = "MONGO_MONITORING_IO", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:MONGO_MONITORING_IO::" },
      { name = "MONGO_SERVER_SELECTION_TIMEOUT", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:MONGO_SERVER_SELECTION_TIMEOUT::" },
      { name = "MONGO_SOCKET_TIMEOUT", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:MONGO_SOCKET_TIMEOUT::" },
      { name = "MONGO_URL", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:MONGO_URL::" },
      { name = "REDIS_URL", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:REDIS_URL::" },
      { name = "SECRET_KEY_BASE", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:SECRET_KEY_BASE::" },
      { name = "USER_ANONYMIZING_WINDOW", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:USER_ANONYMIZING_WINDOW::" },
      { name = "WEB_CONCURRENCY", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:WEB_CONCURRENCY::" },
      { name = "WEB_MAX_THREADS", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:WEB_MAX_THREADS::" },
      { name = "ROLLBAR_SERVER_ACCESS_TOKEN", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:ROLLBAR_SERVER_ACCESS_TOKEN::" },
      { name = "ROLLBAR_CLIENT_ACCESS_TOKEN", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:ROLLBAR_CLIENT_ACCESS_TOKEN::" },
      { name = "RAILS_SERVE_STATIC_FILES", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:RAILS_SERVE_STATIC_FILES::" },
      { name = "RAILS_PG_EXTRAS_PUBLIC_DASHBOARD", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:RAILS_PG_EXTRAS_PUBLIC_DASHBOARD::" },
      { name = "RAILS_MASTER_KEY", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:RAILS_MASTER_KEY::" },
      { name = "RAILS_LOG_TO_STDOUT", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:RAILS_LOG_TO_STDOUT::" },
      { name = "RACK_TIMEOUT_WAIT_TIMEOUT", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:RACK_TIMEOUT_WAIT_TIMEOUT::" },
      { name = "RACK_TIMEOUT_WAIT_OVERTIME", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:RACK_TIMEOUT_WAIT_OVERTIME::" },
      { name = "RACK_TIMEOUT_SERVICE_TIMEOUT", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:RACK_TIMEOUT_SERVICE_TIMEOUT::" },
      { name = "RACK_ENV", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:RACK_ENV::" },
      { name = "PG_STATEMENT_TIMEOUT", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:PG_STATEMENT_TIMEOUT::" },
      { name = "PG_CHECKOUT_TIMEOUT", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:PG_CHECKOUT_TIMEOUT::" },
      { name = "PG_CONNECT_TIMEOUT", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:PG_CONNECT_TIMEOUT::" },
      { name = "PGBOUNCER_PREPARED_STATEMENTS", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:PGBOUNCER_PREPARED_STATEMENTS::" },
      { name = "NEW_RELIC_LICENSE_KEY", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:NEW_RELIC_LICENSE_KEY::" },
      { name = "NEW_RELIC_APP_NAME", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:NEW_RELIC_APP_NAME::" },
      { name = "NEW_RELIC_AGENT_ENABLED", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:NEW_RELIC_AGENT_ENABLED::" },
      { name = "LANG", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:LANG::" },
      { name = "HIREFIRE_TOKEN", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:HIREFIRE_TOKEN::" },
      { name = "ENVIRONMENT", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:ENVIRONMENT::" },
      { name = "DOMAIN", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:DOMAIN::" },
      { name = "DISABLE_DATADOG_AGENT", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:DISABLE_DATADOG_AGENT::" },
      { name = "DD_TRACE_ANALYTICS_ENABLED", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:DD_TRACE_ANALYTICS_ENABLED::" },
      { name = "DD_PROCESS_AGENT", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:DD_PROCESS_AGENT::" },
      { name = "DD_LOG_TO_CONSOLE", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:DD_LOG_TO_CONSOLE::" },
      { name = "DD_LOGS_ENABLED", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:DD_LOGS_ENABLED::" },
      { name = "DD_DYNO_HOST", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:DD_DYNO_HOST::" },
      { name = "DD_DISABLE_HOST_METRICS", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:DD_DISABLE_HOST_METRICS::" },
      { name = "DD_APM_ENABLED", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:DD_APM_ENABLED::" },
      { name = "DD_API_KEY", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:DD_API_KEY::" },
      { name = "DATA_DOG_APPLICATION_KEY", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:DATA_DOG_APPLICATION_KEY::" },
      { name = "DATA_DOG_API_KEY", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:DATA_DOG_API_KEY::" },
      { name = "DATABASE_URL_DEPRECATED", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:DATABASE_URL_DEPRECATED::" },
      { name = "CURRENCY_API_KEY", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:CURRENCY_API_KEY::" },
      { name = "CORS_ORIGINS", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:CORS_ORIGINS::" },
      { name = "COMPANY_ANONYMIZING_WINDOW", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:COMPANY_ANONYMIZING_WINDOW::" },
      { name = "BUNDLE_WITHOUT", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:BUNDLE_WITHOUT::" },
      { name = "AWS_BUCKET", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:AWS_BUCKET::" },
      { name = "PATH", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:PATH::" },
      { name = "PG_PRIMARY_URL", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:PG_PRIMARY_URL::" },
      { name = "DATABASE_URL", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta_database-GPdRwb:DATABASE_URL::" },
      { name = "AWS_ACCESS_KEY_ID", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:AWS_ACCESS_KEY_ID::" },
      { name = "AWS_S3_REGION", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:AWS_S3_REGION::" },
      { name = "AWS_SECRET_ACCESS_KEY", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:AWS_SECRET_ACCESS_KEY::" },
      { name = "ENABLE_DEVELOPMENT_APP_COR", valueFrom = "arn:aws:secretsmanager:us-east-1:405749097490:secret:beta-app001-secret-PvQGwb:ENABLE_DEVELOPMENT_APP_COR::" }
    ]

    execution_role_arn = "arn:aws:iam::405749097490:role/ecsTaskExecutionRole"
    task_role_arn      = "arn:aws:iam::405749097490:role/ecsTaskExecutionRole"

    cloudwatch_log_group_name   = "/ecs/beta-worker_commission_white_shark"
    create_cloudwatch_log_group = true
    enable_cloudwatch_logging   = true
  }


}

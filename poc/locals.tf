locals {
  services = {
    for k, v in var.services :
    k => merge(
      v,
      {
        env = merge(
          lookup(v, "env", {}),
          { ALB_HOSTNAME = module.internal_alb.alb_dns_name }
        )
        load_balancers                     = lookup(v, "load_balancers", [])
        deployment_controller_type         = lookup(v, "deployment_controller_type", null)
        deployment_minimum_healthy_percent = lookup(v, "deployment_minimum_healthy_percent", 50)
        deployment_maximum_percent         = lookup(v, "deployment_maximum_percent", 200)
        enable_deployment_circuit_breaker  = lookup(v, "enable_deployment_circuit_breaker", true)
        deployment_rollback                = lookup(v, "deployment_rollback", true)
        create_cloudwatch_log_group        = lookup(v, "create_cloudwatch_log_group", false)
      },
      k == var.service_with_alb ? {
        load_balancers = [{
          target_group_arn = module.internal_alb.target_group_arn
          container_name   = lookup(v, "container_name", k)
          container_port   = lookup(v, "container_port", null)
        }]
        # CodeDeploy gerencia o blue/green, não precisa de advanced_configuration
        advanced_configuration             = null
        deployment_controller_type         = "CODE_DEPLOY"
        deployment_minimum_healthy_percent = 100
        deployment_maximum_percent         = 200
        # CodeDeploy não usa deployment_configuration do ECS
        deployment_strategy                = null
        bake_time_in_minutes               = null
        # Circuit breaker não é usado com CODE_DEPLOY (CodeDeploy tem seu próprio rollback)
        enable_deployment_circuit_breaker  = false
        deployment_rollback                = false
        } : {
        load_balancers                     = lookup(v, "load_balancers", [])
        advanced_configuration             = lookup(v, "advanced_configuration", null)
        deployment_controller_type         = lookup(v, "deployment_controller_type", null)
        deployment_minimum_healthy_percent = lookup(v, "deployment_minimum_healthy_percent", 50)
        deployment_maximum_percent         = lookup(v, "deployment_maximum_percent", 200)
        deployment_strategy                = lookup(v, "deployment_strategy", null)
        bake_time_in_minutes               = lookup(v, "bake_time_in_minutes", null)
        enable_deployment_circuit_breaker  = lookup(v, "enable_deployment_circuit_breaker", true)
        deployment_rollback                = lookup(v, "deployment_rollback", true)
      }
    )
  }
}

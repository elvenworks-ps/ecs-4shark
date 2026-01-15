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
        enable_deployment_circuit_breaker  = lookup(v, "enable_deployment_circuit_breaker", false)
        deployment_rollback                = lookup(v, "deployment_rollback", true)
      },
      k == var.service_with_alb ? {
        load_balancers = [{
          target_group_arn = module.internal_alb.target_group_arn
          container_name   = lookup(v, "container_name", k)
          container_port   = lookup(v, "container_port", null)
        }]
        advanced_configuration = var.enable_blue_green ? {
          alternate_target_group_arn = module.internal_alb.alternate_target_group_arn
          production_listener_rule   = module.internal_alb.production_listener_rule_arn
          role_arn                   = coalesce(var.ecs_service_bluegreen_role_arn, module.internal_alb.blue_green_role_arn)
          test_listener_rule         = module.internal_alb.test_listener_rule_arn
        } : null
        deployment_controller_type         = "ECS"
        deployment_minimum_healthy_percent = 0
        deployment_maximum_percent         = 200
        enable_deployment_circuit_breaker  = true
        deployment_rollback                = true
        } : {
        load_balancers                     = lookup(v, "load_balancers", [])
        advanced_configuration             = lookup(v, "advanced_configuration", null)
        deployment_controller_type         = lookup(v, "deployment_controller_type", null)
        deployment_minimum_healthy_percent = lookup(v, "deployment_minimum_healthy_percent", 50)
        deployment_maximum_percent         = lookup(v, "deployment_maximum_percent", 200)
        enable_deployment_circuit_breaker  = lookup(v, "enable_deployment_circuit_breaker", false)
        deployment_rollback                = lookup(v, "deployment_rollback", true)
      }
    )
  }
}

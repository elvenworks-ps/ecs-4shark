locals {
  environment_list = [
    for k, v in var.environment_variables : {
      name  = k
      value = v
    }
  ]

  log_group_name = coalesce(
    var.cloudwatch_log_group_name,
    "/aws/ecs/${var.service_name}"
  )
}

#output "vpc_id" {
#  value = module.vpc_data.vpc_id
#}
#
#
#output "private_subnets" {
#    description = "List of IDs of private subnets"
#    value       = module.vpc["main"].private_subnet_ids
#}
#
#output "public_ids" {
#    description = "List of IDs of public subnets"
#    value       = module.vpc["main"].public_subnet_ids
#}
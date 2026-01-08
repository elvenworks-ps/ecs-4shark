output "vpc_id" {
  value = module.vpc_data.vpc_id
}


output "private_ids" {
  value = module.vpc_data.private_ids
}

output "public_ids" {
  value = module.vpc_data.public_ids
}

output "vpc_id" {
  value = module.base_network.vpc_id
}

output "vpc_cidr" {
  value = module.base_network.vpc_cidr
}

output "public_subnet_ids" {
  value = module.base_network.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.base_network.private_subnet_ids
}

output "public_zone_id" {
  value = module.dns_zones.public_zone_id
}

output "public_zone_name_servers" {
  value = module.dns_zones.public_zone_name_servers
}

output "private_zone_id" {
  value = module.dns_zones.private_zone_id
}

output "private_zone_name_servers" {
  value = module.dns_zones.private_zone_name_servers
}

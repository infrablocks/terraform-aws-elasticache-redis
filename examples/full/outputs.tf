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

output "subnet_group_name" {
  value = module.elasticache_redis.subnet_group_name
}

output "security_group_arn" {
  value = module.elasticache_redis.security_group_arn
}

output "security_group_id" {
  value = module.elasticache_redis.security_group_id
}

output "replication_group_id" {
  value = module.elasticache_redis.replication_group_id
}

output "primary_endpoint_address" {
  value = module.elasticache_redis.primary_endpoint_address
}

output "primary_endpoint_port" {
  value = module.elasticache_redis.primary_endpoint_port
}

output "member_clusters" {
  value = module.elasticache_redis.member_clusters
}

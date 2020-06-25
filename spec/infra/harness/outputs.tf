output "subnet_group_name" {
  value = module.elasticache_redis.subnet_group_name
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

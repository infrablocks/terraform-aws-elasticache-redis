output "subnet_group_name" {
  value = "${module.elasticache_redis.subnet_group_name}"
}

output "replication_group_id" {
  value = "${module.elasticache_redis.replication_group_id}"
}

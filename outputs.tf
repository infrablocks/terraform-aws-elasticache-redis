output "subnet_group_name" {
  value = "${aws_elasticache_subnet_group.subnet_group.name}"
}

output "replication_group_id" {
  value = "${aws_elasticache_replication_group.replication_group.id}"
}

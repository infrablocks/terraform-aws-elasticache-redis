output "subnet_group_name" {
  value = "${aws_elasticache_subnet_group.subnet_group.name}"
}

output "replication_group_id" {
  value = "${coalesce(var.replication_group_id, data.template_file.replication_group_id.rendered)}"
}

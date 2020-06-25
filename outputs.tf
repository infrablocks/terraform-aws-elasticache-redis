output "subnet_group_name" {
  value = aws_elasticache_subnet_group.subnet_group.name
}

output "security_group_arn" {
  value = aws_security_group.security_group.arn
}

output "security_group_id" {
  value = aws_security_group.security_group.id
}

output "replication_group_id" {
  value = coalesce(var.replication_group_id, data.template_file.replication_group_id.rendered)
}

output "primary_endpoint_address" {
  value = aws_elasticache_replication_group.replication_group.primary_endpoint_address
}

output "primary_endpoint_port" {
  value = var.redis_port
}

output "member_clusters" {
  value = aws_elasticache_replication_group.replication_group.member_clusters
}

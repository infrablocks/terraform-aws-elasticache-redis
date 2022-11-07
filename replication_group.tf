resource "random_string" "replication_group_id_first" {
  length  = 1
  number  = false
  special = false
  upper   = false

  keepers = {
    component             = var.component
    deployment_identifier = var.deployment_identifier
  }
}

resource "random_string" "replication_group_id_rest" {
  length  = 19
  upper   = false
  special = false

  keepers = {
    component             = var.component
    deployment_identifier = var.deployment_identifier
  }
}

locals {
  random_replication_group_id = "${random_string.replication_group_id_first.result}${random_string.replication_group_id_rest.result}"
}

resource "aws_elasticache_replication_group" "replication_group" {
  replication_group_id          = coalesce(local.replication_group_id, local.random_replication_group_id)
  replication_group_description = "elasticache-redis-replication-group-${var.component}-${var.deployment_identifier}"

  engine_version = local.engine_version

  number_cache_clusters = var.node_count
  node_type             = var.node_type

  port = local.redis_port

  security_group_ids = [aws_security_group.security_group.id]
  subnet_group_name  = aws_elasticache_subnet_group.subnet_group.name

  auth_token = local.auth_token == "" ? null : local.auth_token

  automatic_failover_enabled = local.enable_automatic_failover == "yes" ? true : false
  at_rest_encryption_enabled = local.enable_encryption_at_rest == "yes" ? true : false
  transit_encryption_enabled = local.enable_encryption_in_transit == "yes" ? true : false

  apply_immediately = local.apply_immediately == "yes" ? true : false

  tags = {
    Name                 = "elasticache-redis-${var.component}-${var.deployment_identifier}"
    Component            = var.component
    DeploymentIdentifier = var.deployment_identifier
  }
}

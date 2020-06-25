resource "random_string" "replication_group_id_first" {
  length = 1
  number = false
  special = false
  upper = false

  keepers = {
    component = var.component
    deployment_identifier = var.deployment_identifier
  }
}

resource "random_string" "replication_group_id_rest" {
  length = 19
  upper = false
  special = false

  keepers = {
    component = var.component
    deployment_identifier = var.deployment_identifier
  }
}

data "template_file" "replication_group_id" {
  template = "$${first}$${rest}"

  vars = {
    first = random_string.replication_group_id_first.result
    rest = random_string.replication_group_id_rest.result
  }
}

resource "aws_elasticache_replication_group" "replication_group" {
  replication_group_id = coalesce(var.replication_group_id, data.template_file.replication_group_id.rendered)
  replication_group_description = "elasticache-redis-replication-group-${var.component}-${var.deployment_identifier}"

  engine_version = var.engine_version

  number_cache_clusters = var.node_count
  node_type = var.node_type

  subnet_group_name = aws_elasticache_subnet_group.subnet_group.name

  auth_token = var.auth_token == "" ? null : var.auth_token

  automatic_failover_enabled = var.enable_automatic_failover == "yes" ? true : false
  at_rest_encryption_enabled = var.enable_encryption_at_rest == "yes" ? true : false
  transit_encryption_enabled = var.enable_encryption_in_transit == "yes" ? true : false

  apply_immediately = var.apply_immediately == "yes" ? true : false

  tags = {
    Name = "elasticache-redis-${var.component}-${var.deployment_identifier}"
    Component = var.component
    DeploymentIdentifier = var.deployment_identifier
  }
}

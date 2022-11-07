locals {
  # default for cases when `null` value provided, meaning "use default"
  redis_port                   = var.redis_port == null ? 6379 : var.redis_port
  replication_group_id         = var.replication_group_id == null ? "" : var.replication_group_id
  engine_version               = var.engine_version == null ? "5.0.6" : var.engine_version
  apply_immediately            = var.apply_immediately == null ? "no" : var.apply_immediately
  auth_token                   = var.auth_token == null ? "" : var.auth_token
  enable_automatic_failover    = var.enable_automatic_failover == null ? "yes" : var.enable_automatic_failover
  enable_encryption_at_rest    = var.enable_encryption_at_rest == null ? "yes" : var.enable_encryption_at_rest
  enable_encryption_in_transit = var.enable_encryption_in_transit == null ? "yes" : var.enable_encryption_in_transit
}

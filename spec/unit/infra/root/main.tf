data "terraform_remote_state" "prerequisites" {
  backend = "local"

  config = {
    path = "${path.module}/../../../../state/prerequisites.tfstate"
  }
}

module "elasticache_redis" {
  source = "../../../.."

  component = var.component
  deployment_identifier = var.deployment_identifier

  vpc_id = data.terraform_remote_state.prerequisites.outputs.vpc_id
  subnet_ids = data.terraform_remote_state.prerequisites.outputs.private_subnet_ids

  allowed_cidrs = var.allowed_cidrs

  replication_group_id = var.replication_group_id

  redis_port = var.redis_port

  engine_version = var.engine_version

  node_count = var.node_count
  node_type = var.node_type

  auth_token = var.auth_token

  enable_automatic_failover = var.enable_automatic_failover
  enable_encryption_at_rest = var.enable_encryption_at_rest
  enable_encryption_in_transit = var.enable_encryption_in_transit

  apply_immediately = var.apply_immediately
}

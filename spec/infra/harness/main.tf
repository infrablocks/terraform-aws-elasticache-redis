data "terraform_remote_state" "prerequisites" {
  backend = "local"

  config {
    path = "${path.module}/../../../../state/prerequisites.tfstate"
  }
}

module "elasticache_redis" {
  source = "../../../../"

  component = "${var.component}"
  deployment_identifier = "${var.deployment_identifier}"

  subnet_ids = "${split(",", data.terraform_remote_state.prerequisites.private_subnet_ids)}"

  replication_group_id = "${var.replication_group_id}"

  node_count = "${var.node_count}"
  node_type = "${var.node_type}"

  auth_token = "${var.auth_token}"

  enable_automatic_failover = "${var.enable_automatic_failover}"
  enable_encryption_at_rest = "${var.enable_encryption_at_rest}"
  enable_encryption_in_transit = "${var.enable_encryption_in_transit}"

  apply_immediately = "${var.apply_immediately}"
}

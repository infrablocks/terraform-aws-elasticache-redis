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
}

module "elasticache_redis" {
  source = "../../"

  component = var.component
  deployment_identifier = var.deployment_identifier

  vpc_id = module.base_network.vpc_id
  subnet_ids = module.base_network.private_subnet_ids

  allowed_cidrs = ["10.0.0.0/8"]

  node_count = 2
  node_type = "cache.t2.micro"

  auth_token = var.auth_token
}

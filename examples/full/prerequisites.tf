resource "aws_default_vpc" "default" {}

module "dns_zones" {
  source  = "infrablocks/dns-zones/aws"
  version = "1.0.0"

  domain_name             = var.domain_name
  private_domain_name     = var.domain_name
  private_zone_vpc_id     = aws_default_vpc.default.id
  private_zone_vpc_region = var.region
}

module "base_network" {
  source  = "infrablocks/base-networking/aws"
  version = "4.0.0"

  region             = var.region
  vpc_cidr           = var.vpc_cidr
  availability_zones = var.availability_zones

  component             = var.component
  deployment_identifier = var.deployment_identifier

  private_zone_id = module.dns_zones.private_zone_id
}

resource "aws_elasticache_subnet_group" "subnet_group" {
  name="elasticache-redis-subnet-group-${var.component}-${var.deployment_identifier}"
  subnet_ids = ["${var.subnet_ids}"]
}
resource "aws_security_group" "security_group" {
  name        = "elasticache-redis-security-group-${var.component}-${var.deployment_identifier}"
  description = "Allow access to ${var.component} Redis instance from private network."
  vpc_id      = var.vpc_id

  tags = {
    Name                 = "sg-elasticache-redis-${var.component}-${var.deployment_identifier}"
    Component            = var.component
    DeploymentIdentifier = var.deployment_identifier
  }

  ingress {
    from_port   = local.redis_port
    to_port     = local.redis_port
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidrs
  }
}

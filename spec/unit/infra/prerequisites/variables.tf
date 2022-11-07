variable "region" {}
variable "vpc_cidr" {}
variable "availability_zones" {
  type = list(string)
}

variable "component" {}
variable "deployment_identifier" {}

variable "domain_name" {}

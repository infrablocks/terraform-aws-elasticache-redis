variable "region" {}

variable "component" {}
variable "deployment_identifier" {}

variable "vpc_cidr" {}
variable "availability_zones" {
  type = list(string)
}

variable "domain_name" {}

variable "auth_token" {}

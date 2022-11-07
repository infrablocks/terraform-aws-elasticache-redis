variable "region" {}

variable "component" {}
variable "deployment_identifier" {}

variable "allowed_cidrs" {
  type = list(string)
}

variable "replication_group_id" {
  default = null
}

variable "redis_port" {
  type = number
  default = null
}

variable "node_count" {
  type = number
  default = null
}
variable "node_type" {}

variable "engine_version" {
  default = null
}

variable "auth_token" {
  default = null
}

variable "enable_automatic_failover" {
  default = null
}
variable "enable_encryption_at_rest" {
  default = null
}
variable "enable_encryption_in_transit" {
  default = null
}

variable "apply_immediately" {
  default = null
}

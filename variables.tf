variable "vpc_id" {
  description = "The ID of the VPC into which to deploy the elasticache redis instance."
}
variable "subnet_ids" {
  description = "The IDs of the subnets for elasticache redis nodes."
  type = list(string)
}

variable "allowed_cidrs" {
  description = "The CIDRs allowed access to the elasticache redis instance."
  type = list(string)
}

variable "component" {
  description = "The component this elasticache redis instance will contain."
}
variable "deployment_identifier" {
  description = "An identifier for this elasticache redis instance."
}

variable "redis_port" {
  description = "The port the elasticache redis instance should run on."
  type = number
  default = 6379
}

variable "replication_group_id" {
  description = "The ID for the replication group. Defaults to a randomly generated ID."
  default = ""
}

variable "engine_version" {
  description = "The version of redis to use."
  default = "5.0.6"
}

variable "node_count" {
  description = "The number of cache nodes to include."
  type = number
}
variable "node_type" {
  description = "The instance type of the cache nodes."
}

variable "apply_immediately" {
  description = "Whether or not to apply modifications immediately."
  default = "no"
}

variable "auth_token" {
  description = "The authorisation token used to access the elasticache redis instance."
  default = ""
}

variable "enable_automatic_failover" {
  description = "Whether or not to enable automatic failover for the replication group"
  default = "yes"
}
variable "enable_encryption_at_rest" {
  description = "Whether or not to enable encryption at rest in the replication group"
  default = "yes"
}
variable "enable_encryption_in_transit" {
  description = "Whether or not to enable encryption in transit in the replication group"
  default = "yes"
}

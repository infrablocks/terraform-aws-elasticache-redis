variable "subnet_ids" {
  description = "The IDs of the subnets for elasticache nodes."
  type = "list"
}

variable "component" {
  description = "The component this elasticache instance will contain."
}
variable "deployment_identifier" {
  description = "An identifier for this elasticache instance."
}

variable "node_count" {
  description = "The number of cache nodes to include."
}
variable "node_type" {
  description = "The instance type of the cache nodes."
}

variable "apply_immediately" {
  description = "Whether or not to apply modifications immediately."
  default = "no"
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

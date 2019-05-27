variable "subnet_ids" {
  description = "The IDs of the subnets for elasticache nodes."
  type = "list"
}

variable "component" {
  description = "The component this elasticache cluster will contain."
}
variable "deployment_identifier" {
  description = "An identifier for this instantiation."
}

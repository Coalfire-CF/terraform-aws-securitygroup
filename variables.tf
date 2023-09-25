variable "name" {
  description = "The name of the created security group. Conflicts with 'sg_name_prefix'"
  type        = string
  default     = ""
}

variable "sg_name_prefix" {
  description = "The prefix to be used while generating a unique name for the security group. Conflicts with 'sg_name'"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags to add to the created security group"
  type        = map(string)
  default     = {}
}

variable "description" {
  description = "This overwrites the default generated description for the security group"
  type        = string
  default     = "Managed by Terraform"
}

variable "vpc_id" {
  description = "The ID of the VPC that the security group will be associated with"
  type        = string
  default     = null
}

variable "network_interface_resource_associations" {
  description = "The IDs of already existing network interfaces to be associated with the created security group. If used, do not declare sg in the creation of those resources"
  type        = list(string)
  default     = []
}

variable "ingress_rules" {
  description = "The list of rules for ingress traffic. Required fields for each rule are 'protocol', 'from_port', 'to_port', and at least one of 'cidr_blocks', 'ipv6_cidr_blocks', 'security_groups', 'self', or 'prefix_list_sg'. Optional fields are 'description' and those not used from the previous list"
  type = list(object({
    protocol         = string
    from_port        = string
    to_port          = string
    cidr_blocks      = optional(list(string), [])
    ipv6_cidr_blocks = optional(list(string), [])
    prefix_list_ids  = optional(list(string), [])
    security_groups  = optional(list(string), [])
    self             = optional(bool)
    description      = optional(string, "Managed by Terraform")
  }))
  default = []
}

variable "egress_rules" {
  description = "The list of rules for egress traffic. Required fields for each rule are 'protocol', 'from_port', 'to_port', and at least one of 'cidr_blocks', 'ipv6_cidr_blocks', 'security_groups', 'self', or 'prefix_list_sg'. Optional fields are 'description' and those not used from the previous list"
  type = list(object({
    protocol         = string
    from_port        = string
    to_port          = string
    cidr_blocks      = optional(list(string), [])
    ipv6_cidr_blocks = optional(list(string), [])
    prefix_list_ids  = optional(list(string), [])
    security_groups  = optional(list(string), [])
    self             = optional(bool)
    description      = optional(string, "Managed by Terraform")
  }))
  default = []
}
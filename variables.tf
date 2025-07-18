variable "name" {
  description = "The name of the created security group. Conflicts with 'sg_name_prefix'"
  type        = string
}

variable "sg_name_prefix" {
  description = "The prefix to be used while generating a unique name for the security group. Conflicts with 'sg_name'"
  type        = string
}

variable "tags" {
  type        = map(any)
  description = "Additional tags (e.g. map(`BusinessUnit`,`XYZ`)."
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
  type = map(object({
    cidr_ipv4                    = optional(string, null)
    cidr_ipv6                    = optional(string, null)
    description                  = optional(string, "Managed by Terraform")
    from_port                    = optional(string, null)
    ip_protocol                  = optional(string, null)
    prefix_list_id               = optional(string, null)
    referenced_security_group_id = optional(string, null)
    to_port                      = optional(string, null)
  }))
  default = {}
}

variable "egress_rules" {
  description = "The list of rules for egress traffic. Required fields for each rule are 'protocol', 'from_port', 'to_port', and at least one of 'cidr_blocks', 'ipv6_cidr_blocks', 'security_groups', 'self', or 'prefix_list_sg'. Optional fields are 'description' and those not used from the previous list"
  type = map(object({
    cidr_ipv4                    = optional(string, null)
    cidr_ipv6                    = optional(string, null)
    description                  = optional(string, "Managed by Terraform")
    from_port                    = optional(string, null)
    ip_protocol                  = optional(string, null)
    prefix_list_id               = optional(string, null)
    referenced_security_group_id = optional(string, null)
    to_port                      = optional(string, null)
  }))
  default = {}
}
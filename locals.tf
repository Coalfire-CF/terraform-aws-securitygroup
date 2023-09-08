locals {
  use_prefix = var.sg_name_prefix != "" ? true : false
}

# Ensure dynamic blocks run
locals {
  ingress_rules = length(var.ingress_rules) == 0 ? [object()] : var.ingress_rules
  egress_rules = length(var.ingress_rules) == 0 ? [object()] : var.egress_rules
}
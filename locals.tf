locals {
  use_prefix = var.sg_name_prefix != "" ? true : false
}

# Ensure dynamic blocks run
locals {
  ingress_rules = var.ingress_rules == null ? [] : var.ingress_rules
  egress_rules  = var.egress_rules == null ? [] : var.egress_rules
}
resource "aws_security_group" "this" {
  name        = local.use_prefix ? null : var.name
  name_prefix = local.use_prefix ? var.sg_name_prefix : null
  description = var.description
  vpc_id      = var.vpc_id
  tags        = local.internal_tags
}

resource "aws_vpc_security_group_ingress_rule" "this" {
  for_each = var.ingress_rules

  security_group_id            = aws_security_group.this.id
  cidr_ipv4                    = try(each.value.cidr_ipv4, null)
  cidr_ipv6                    = try(each.value.cidr_ipv6, null)
  description                  = try(each.value.description, null)
  from_port                    = try(each.value.from_port, null)
  ip_protocol                  = try(each.value.ip_protocol, null)
  prefix_list_id               = try(each.value.prefix_list_id, null)
  referenced_security_group_id = try(each.value.referenced_security_group_id, null) == "self" ? aws_security_group.this.id : try(each.value.referenced_security_group_id, null)
  to_port                      = try(each.value.to_port, null)
}

resource "aws_vpc_security_group_egress_rule" "this" {
  for_each = var.egress_rules

  security_group_id            = aws_security_group.this.id
  cidr_ipv4                    = try(each.value.cidr_ipv4, null)
  cidr_ipv6                    = try(each.value.cidr_ipv6, null)
  description                  = try(each.value.description, null)
  from_port                    = try(each.value.from_port, null)
  ip_protocol                  = try(each.value.ip_protocol, null)
  prefix_list_id               = try(each.value.prefix_list_id, null)
  referenced_security_group_id = try(each.value.referenced_security_group_id, null) == "self" ? aws_security_group.this.id : try(each.value.referenced_security_group_id, null)
  to_port                      = try(each.value.to_port, null)
}

resource "aws_network_interface_sg_attachment" "this" {
  count = length(var.network_interface_resource_associations)

  security_group_id    = aws_security_group.this.id
  network_interface_id = var.network_interface_resource_associations[count.index]
}

# For exporting network interface ARNs
data "aws_network_interface" "interfaces" {
  count = length(var.network_interface_resource_associations)

  id = var.network_interface_resource_associations[count.index]
}
resource "aws_security_group" "this" {
  name        = local.use_prefix ? null : var.name
  name_prefix = local.use_prefix ? var.sg_name_prefix : null

  description = var.description

  vpc_id = var.vpc_id

  ingress = [
    for rule in local.ingress_rules : merge(null, rule)
  ]

  egress = [
    for rule in local.egress_rules : merge(null, rule)
  ]

  tags = var.tags
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

resource "aws_security_group" "this" {
  name        = local.use_prefix ? null : var.name
  name_prefix = local.use_prefix ? var.sg_name_prefix : null

  description = var.description

  vpc_id = var.vpc_id

  ingress = [
    for rule in var.ingress_rules: merge(null, rule)
  ]

  egress = [
    for rule in var.egress_rules: merge(null, rule)
  ]

  # dynamic "ingress" {
  #   for_each = var.ingress_rules

  #   content {
  #     description = ingress.value["description"]

  #     protocol = ingress.value["protocol"]
  #     # Required unless protocol == "-1" or "icmpv6"
  #     from_port = ingress.value["from_port"]
  #     to_port   = ingress.value["to_port"]

  #     # Must have at least one of these        
  #     cidr_blocks      = ingress.value["cidr_blocks"]
  #     ipv6_cidr_blocks = ingress.value["ipv6_cidr_blocks"]
  #     security_groups  = ingress.value["security_groups"]
  #     prefix_list_ids  = ingress.value["prefix_list_ids"]

  #     self = ingress.value["self"]
  #   }
  # }

  # dynamic "egress" {
  #   for_each = var.egress_rules

  #   content {
  #     description = egress.value["description"]

  #     protocol  = egress.value["protocol"]
  #     from_port = egress.value["from_port"]
  #     to_port   = egress.value["to_port"]

  #     # Must have at least one of these        
  #     cidr_blocks      = egress.value["cidr_blocks"]
  #     ipv6_cidr_blocks = egress.value["ipv6_cidr_blocks"]
  #     security_groups  = egress.value["security_groups"]
  #     prefix_list_ids  = egress.value["prefix_list_ids"]

  #     self = egress.value["self"]
  #   }
  # }

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

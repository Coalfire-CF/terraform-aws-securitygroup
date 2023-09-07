output "id" {
  value       = aws_security_group.main.id
  description = "The id of the created security group"
}

output "associated_network_interfaces" {
  value       = data.aws_network_interface.interfaces.*.arn
  description = "The ARNs of the network interfaces associated to the security group by this module"
}
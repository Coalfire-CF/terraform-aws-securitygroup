output "sg_id" {
  value       = module.example_sg.id
  description = "The ID of the created security group"
}

output "associated_network_interfaces" {
  value       = module.example_sg.associated_network_interfaces
  description = "The ARNs of the network interfaces attached by the SG module"
}
output "virtual_network_interfaces_ids" {
  value = azurerm_network_interface.network_interfaces[*].id
}

output "public_ip_addresses" {
  value = azurerm_public_ip.public_ipaddress[*].ip_address
}


output "virtual_network_id" {
  value = azurerm_virtual_network.virtual_network.id
}

output "network_interface_private_ip_address" {
  value = azurerm_network_interface.network_interfaces[*].private_ip_address
}

output "virtual_network_subnet_id" {
  value = azurerm_subnet.network_subnets[*].id
}

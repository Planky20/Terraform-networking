output "subnet_ids" {
  value = values(azurerm_subnet.network_subnets)[*].id
}

output "private_ip_address" { # Building a map: the interface name will be the KEY and private ip address will be the VALUE
  value = {
    for interface in azurerm_network_interface.network_interfaces :
    interface.name => ({
      private_ip_address = interface.private_ip_address
    })
  }
}

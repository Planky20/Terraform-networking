output "subnet_ids" {
  value = {
    for subnet in azurerm_subnet.network_subnets :
    subnet.name => ({
      subnet_id = subnet.id
    })
  }
}

output "private_ip_address" { # Building a map: the interface name will be the KEY and private ip address will be the VALUE
  value = {
    for interface in azurerm_network_interface.network_interfaces :
    interface.name => ({
      private_ip_address = interface.private_ip_address
    })
  }
}

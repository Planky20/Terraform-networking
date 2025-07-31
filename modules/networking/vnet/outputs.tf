output "subnet_ids" {
  value = values(azurerm_subnet.network_subnets)[*].id
}

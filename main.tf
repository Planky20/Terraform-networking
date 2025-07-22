module "resource-group" {
  source              = "./modules/general/resourcegroup"
  resource_group_name = var.resource_group_name
  location            = var.location
}

module "network" {
  source                       = "./modules/networking/vnet"
  for_each                     = var.environment
  resource_group_name          = var.resource_group_name
  location                     = var.location
  vnet_name                    = each.value.virtual_network_name
  vnet_address_prefix          = each.value.virtual_network_address_space
  vnet_subnet_count            = each.value.subnet_count
  public_ip_address_count      = each.value.public_ip_address_count
  network_interfaces_count     = each.value.network_interface_count
  network_security_group_rules = var.network_security_group_rules
  resource_prefix              = each.key
  depends_on                   = [module.resource-group]
}

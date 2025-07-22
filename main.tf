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

module "virtual-machines" {
  for_each                            = var.environment # One machine for each VNET
  source                              = "./modules/compute/virtualMachines"
  resource_group_name                 = var.resource_group_name
  location                            = var.location
  virtual_machine_count               = each.value.virtual_machine_count
  virtual_network_interface_ids       = module.network[each.key].virtual_network_interfaces_ids # From the output of the network module
  virtual_machine_public_ip_addresses = module.network[each.key].public_ip_addresses            # From the output of the network module
  resource_prefix                     = each.key
}

module "resource-group" {
  source              = "./modules/general/resourcegroup"
  resource_group_name = var.resource_group_name
  location            = var.location
}

module "network" {
  source                       = "./modules/networking/vnet"
  resource_group_name          = var.resource_group_name
  location                     = var.location
  network_security_group_rules = var.network_security_group_rules
  virtual_network_details      = local.virtual_network_details
  subnet_details               = local.subnet_details
  network_interface_details    = local.network_interface_details
  depends_on                   = [module.resource-group]
}

module "virtual-machines" {
  source                    = "./modules/compute/virtualMachines"
  resource_group_name       = var.resource_group_name
  location                  = var.location
  container_name            = "scripts"
  storage_account_name      = module.storage-account.storage_account_name # Name of an output variable from the storage-account module
  network_interface_details = local.network_interface_details
  virtual_machine_details   = local.virtual_machine_details
  depends_on                = [module.network]
}

module "storage-account" {
  source                  = "./modules/storage/azurestorage"
  resource_group_name     = var.resource_group_name
  location                = var.location
  storage_account_details = var.storage_account_details
  container_names         = var.container_names
  blobs                   = var.blobs
  depends_on              = [module.resource-group]
}

module "firewall" {
  source                        = "./modules/networking/firewall"
  resource_group_name           = var.resource_group_name
  location                      = var.location
  virtual_network_name          = "app-network"
  subnet_ids                    = module.network.subnet_ids         # Output for the web and app subnets from the network module
  network_interface_ipaddresses = module.network.private_ip_address # Output for the NICs private IPs from the network module
  firewall_NAT_rules            = var.firewall_NAT_rules
  firewall_application_rules    = var.firewall_application_rules
  depends_on                    = [module.network]
}

output "private_ip_address" {
  value = module.network.private_ip_address
}

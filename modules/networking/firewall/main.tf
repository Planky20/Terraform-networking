resource "azurerm_public_ip" "firewallip" {
  name                = "firewall-ip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
  sku_tier            = "Regional"
}

resource "azurerm_subnet" "firewallsubnet" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  address_prefixes     = ["10.0.10.0/24"]
}

resource "azurerm_firewall_policy" "firewallpolicy" {
  name                = "firewallpolicy"
  resource_group_name = var.resource_group_name
  location            = var.location
}

resource "azurerm_firewall" "appfirewall" {
  name                = "appfirewall"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.firewallsubnet.id
    public_ip_address_id = azurerm_public_ip.firewallip.id
  }

  sku_tier = "Standard"
  sku_name = "AZFW_VNet"

  firewall_policy_id = azurerm_firewall_policy.firewallpolicy.id
}

resource "azurerm_route_table" "firewallroutetable" {
  name                = "firewallroutetable"
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_route" "firewallroute" {
  name                   = "firewallroute"
  resource_group_name    = var.resource_group_name
  route_table_name       = azurerm_route_table.firewallroutetable.name
  address_prefix         = "0.0.0.0/0" # All traffic directed to the Internet will go via Firewall
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = azurerm_firewall.appfirewall.ip_configuration[0].private_ip_address
}

resource "azurerm_subnet_route_table_association" "subnetassociation" {
  for_each  = toset(var.subnet_ids)
  subnet_id = each.key
  route_table_id = azurerm_route_table.firewallroutetable.id
}

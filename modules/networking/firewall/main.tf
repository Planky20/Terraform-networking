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
  for_each       = var.subnet_ids
  subnet_id      = each.value.subnet_id
  route_table_id = azurerm_route_table.firewallroutetable.id
}

resource "azurerm_firewall_policy_rule_collection_group" "rulecollection" {
  name               = "rulecollection"
  firewall_policy_id = azurerm_firewall_policy.firewallpolicy.id
  priority           = 500

  nat_rule_collection {
    name     = "nat_rule_collection"
    priority = 300
    action   = "Dnat"

    dynamic "rule" {
      for_each = var.firewall_NAT_rules
      content {
        name                = "Allow${rule.key}"
        protocols           = ["TCP"]
        source_addresses    = ["0.0.0.0/0"]
        destination_address = "${azurerm_public_ip.firewallip.ip_address}" # Public IP of the Firewall
        destination_ports   = [rule.value.destination_port_number]
        translated_address  = var.network_interface_ipaddresses[rule.key].private_ip_address # Private IP address of each NIC fetched from output variable of the vnet module
        translated_port     = "22"
      }
    }
  }
}

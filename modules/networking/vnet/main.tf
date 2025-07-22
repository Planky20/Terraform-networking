resource "azurerm_virtual_network" "virtual_network" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = [var.vnet_address_prefix]
}

resource "azurerm_subnet" "network_subnets" {
  count                = var.vnet_subnet_count
  name                 = "${var.resource_prefix}subnet${count.index}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes     = [cidrsubnet(var.vnet_address_prefix, 8, count.index)]
}

resource "azurerm_public_ip" "public_ipaddress" {
  count               = var.public_ip_address_count
  name                = "${var.resource_prefix}public-ip0${count.index + 1}"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "network_interfaces" {
  count               = var.network_interfaces_count
  name                = "${var.resource_prefix}interface-0${count.index + 1}"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.network_subnets[count.index].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ipaddress[count.index].id
  }
}

resource "azurerm_network_security_group" "network_security_group" {
  name                = "${var.resource_prefix}network-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name


  dynamic "security_rule" {
    for_each = toset(var.network_security_group_rules)
    content {
      name                       = "Allow-${security_rule.value.destination_port_range}"
      priority                   = security_rule.value.priority
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "subnet_nsg" {
  count                     = var.vnet_subnet_count
  subnet_id                 = azurerm_subnet.network_subnets[count.index].id
  network_security_group_id = azurerm_network_security_group.network_security_group.id
}

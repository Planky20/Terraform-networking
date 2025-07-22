resource_group_name = "app-grp"
location            = "West Europe"

network_security_group_rules = [
  {
    priority               = 300
    destination_port_range = "22"
  },
  {
    priority               = 310
    destination_port_range = "80"
  }
]

environment = {
  app = {
    virtual_network_name          = "app-network"
    virtual_network_address_space = "10.0.0.0/16"
    subnet_count                  = 1
    network_interface_count       = 1
    public_ip_address_count       = 1
    virtual_machine_count         = 1
  }
  test = {
    virtual_network_name          = "test-network"
    virtual_network_address_space = "10.1.0.0/16"
    subnet_count                  = 1
    network_interface_count       = 1
    public_ip_address_count       = 1
    virtual_machine_count         = 1
  }
}

peering_virtual_networks = {
  app-network = {
    virtual_network_key   = "test"
    destination_vnet_name = "test-network"
  }
  test-network = {
    virtual_network_key   = "app"
    destination_vnet_name = "app-network"
  }
}

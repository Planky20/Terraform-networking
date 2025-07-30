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
  app-network = {
    virtual_network_address_space = "10.0.0.0/16"
    subnets = {
      web = {
        subnet_address_prefix = "10.0.0.0/24"
        network_interfaces = [
          {
            name                 = "web-interface-01"
            virtual_machine_name = "webvm01"
            script_name          = "install_web.sh"
          }
        ]
      }
      app = {
        subnet_address_prefix = "10.0.1.0/24"
        network_interfaces = [
          {
            name                 = "app-interface-01"
            virtual_machine_name = "appvm01"
            script_name          = "install_web.sh"
          }
        ]
      }
    }
  }
}

storage_account_details = {
  account_prefix           = "appstore"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
}

container_names = ["scripts", "data"]

blobs = {
  "install_web.sh" = {
    container_name = "scripts"
    blob_location  = "./modules/compute/virtualMachines/install_web.sh"
  }
}


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
            script_name          = "IIS.ps1"
          }
        ]
      }
      app = {
        subnet_address_prefix = "10.0.1.0/24"
        network_interfaces = [
          {
            name                 = "app-interface-01"
            virtual_machine_name = "appvm01"
            script_name          = "IIS.ps1"
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
  "IIS.ps1" = {
    container_name = "scripts"
    blob_location  = "./modules/compute/VirtualMachines/IIS.ps1"
  }
}

firewall_NAT_rules = {
  web-interface-01 = {
    destination_port_number = 4001
  }
  app-interface-01 = {
    destination_port_number = 4002
  }
}

firewall_application_rules = {
  web-interface-01 = {
    allow_url = "www.microsoft.com"
  },
  app-interface-01 = {
    allow_url = "www.microsoft.com"
  }
}

metric_alerts = {
  "Network-threshold-alert" = {
    scope            = "webvm01"
    metric_namespace = "Microsoft.Compute/virtualMachines"
    metric_name      = "Network Out Total"
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = 70000
  },
  "CPU-threshold-alert" = {
    scope            = "appvm01"
    metric_namespace = "Microsoft.Compute/virtualMachines"
    metric_name      = "Percentage CPU"
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = 70
  }
}

user_list = {
  WLtestUser1 = {
    directory_name = "example.com" # Azure domain name
    password       = "StrongPass17!"
    resource_type  = "Microsoft.Compute/virtualMachines"
    resource_name  = "webvm01"
    role           = "Virtual Machine Contributor"
  },
  WLtestUser2 = {
    directory_name = "example.com" # Azure domain name
    password       = "StrongPass17!"
    resource_type  = "Microsoft.Network/virtualNetworks"
    resource_name  = "app-network"
    role           = "Reader"
  }
}

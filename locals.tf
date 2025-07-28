locals {

  virtual_network_details = (flatten([ # Deconstruction and flattening of VNET variable, to have a flat structury containing only VNET name and address space
    for virtualnetwork_key, virtualnetwork in var.environment :
    {
      virtual_network_name          = virtualnetwork_key
      virtual_network_address_space = virtualnetwork.virtual_network_address_space
    }
    ]
  ))


  subnet_details = (flatten([
    for virtualnetwork_key, virtualnetwork in var.environment : [
      for subnet_key, subnets in virtualnetwork.subnets :
      {
        subnet_name           = subnet_key
        virtual_network_name  = virtualnetwork_key
        subnet_address_prefix = subnets.subnet_address_prefix
      }
    ]
    ]
  ))


  network_interface_details = (flatten([
    for virtualnetwork_key, virtualnetwork in var.environment : [
      for subnet_key, subnets in virtualnetwork.subnets : [
        for network_interfaces in subnets.network_interfaces :
        {
          network_interface_name = network_interfaces.name
          subnet_name            = subnet_key
        }
      ]
    ]
    ]
  ))

  virtual_machine_details = (flatten([
    for virtualnetwork_key, virtualnetwork in var.environment : [
      for subnet_key, subnets in virtualnetwork.subnets : [
        for network_interfaces in subnets.network_interfaces :
        {
          network_interface_name = network_interfaces.name
          virtual_machine_name   = network_interfaces.virtual_machine_name
          script_name            = network_interfaces.script_name
        }
      ]
    ]
    ]
  ))

}


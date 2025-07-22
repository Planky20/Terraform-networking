variable "resource_group_name" {
  type        = string
  description = "This defines the name of the resource group"
}

variable "location" {
  type        = string
  description = "This defines the location of the resource group and the resources"
}

variable "network_security_group_rules" {
  type = list(object(
    {
      priority               = number
      destination_port_range = string
    }
  ))
  description = "This defines the network security group rules"
}

variable "environment" {
  type = map(object(
    {
      virtual_network_name          = string
      virtual_network_address_space = string
      subnet_count                  = number
      network_interface_count       = number
      public_ip_address_count       = number
      virtual_machine_count         = number
  }))
}

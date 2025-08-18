variable "resource_group_name" {
  type        = string
  description = "This defines the name of the resource group"
}

variable "location" {
  type        = string
  description = "This defines the location of the resources"
}

variable "virtual_network_name" {
  type = string
}

variable "subnet_ids" {
  type = map(object(
    {
      subnet_id = string
    }
  ))
}

variable "firewall_NAT_rules" {
  type = map(object(
    {
      destination_port_number = number
    }
  ))
}

variable "network_interface_ipaddresses" {
  type = map(object(
    {
      private_ip_address = string
    }
  ))
}

variable "firewall_application_rules" {
  type = map(object(
    {
      allow_url = string
    }
  ))
}

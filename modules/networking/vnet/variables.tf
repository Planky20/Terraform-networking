variable "resource_group_name" {
  type        = string
  description = "This defines the name of the resource group"
}

variable "location" {
  type        = string
  description = "This defines the location of the resources"
}

variable "vnet_name" {
  type        = string
  description = "This defines the name of the virtual network"
}

variable "vnet_address_prefix" {
  type        = string
  description = "This defines the address prefix of the virtual network"
}

variable "vnet_subnet_count" {
  type        = number
  description = "This defines the number of subnets in the virtual network"
}

variable "network_interfaces_count" {
  type        = number
  description = "This defines the number of network interfaces"
}

variable "public_ip_address_count" {
  type        = number
  description = "This defines the number of public ip addresses"
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

variable "resource_prefix" {
  type = string
}

variable "resource_group_name" {
  type        = string
  description = "This defines the name of the resource group"
}

variable "location" {
  type        = string
  description = "This defines the location of the resources"
}

variable "application_gateway_details" {
  type = list(string)
}

variable "application_pool_details" {
  type = map(object(
    {
      network_interface_name = string
    }
  ))
}

variable "network_interface_details" {
  type = list(object(
    {
      network_interface_name = string
      subnet_name            = string
    }
  ))
}

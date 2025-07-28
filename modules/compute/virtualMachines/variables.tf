variable "resource_group_name" {
  type        = string
  description = "This defines the name of the resource group"
}

variable "location" {
  type        = string
  description = "This defines the location of the resources"
}

variable "virtual_machine_details" {
  type = list(object(
    {
      network_interface_name = string
      virtual_machine_name   = string
      script_name            = string
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

variable "storage_account_name" {
  type = string
}

variable "container_name" {
  type = string
}

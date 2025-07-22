variable "resource_group_name" {
  type        = string
  description = "This defines the name of the resource group"
}

variable "source_network_name" {
  type = string
}

variable "destination_vnet_name" {
  type = string
}

variable "destination_network_id" {
  type = string
}

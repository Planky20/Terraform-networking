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
  type = list(string)
}

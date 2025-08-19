variable "resource_group_name" {
  type        = string
  description = "This defines the name of the resource group"
}

variable "location" {
  type        = string
  description = "This defines the location of the resources"
}

variable "virtual_machine_details" {
  type = map(object(
    {
      virtual_machine_id = string
    }
  ))
}

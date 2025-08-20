variable "resource_group_name" {
  type        = string
  description = "This defines the name of the resource group"
}

variable "resource_list" {
  type = map(object(
    {
      resource_type = string
    }
  ))
}

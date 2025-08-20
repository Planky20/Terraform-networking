variable "resource_group_name" {
  type        = string
  description = "This defines the name of the resource group"
}

variable "user_list" {
  type = map(object(
    {
      directory_name = string
      password       = string
      resource_type  = string
      resource_name  = string
      role           = string
    }
  ))
}

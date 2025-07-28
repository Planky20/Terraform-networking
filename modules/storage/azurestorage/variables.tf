variable "resource_group_name" {
  type        = string
  description = "This defines the name of the resource group"
}

variable "location" {
  type        = string
  description = "This defines the location of the resources"
}

variable "storage_account_details" {
  type = map(string)
}

variable "container_names" {
  type = list(string)
}

variable "blobs" {
  type = map(object(
    {
      container_name = string
      blob_location  = string
    }
  ))
}
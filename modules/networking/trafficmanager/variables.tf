variable "resource_group_name" {
  type = string
}

variable "traffic_manager_endpoints" {
  type = map(object(
    {
      priority = number
      weight   = number
    }
  ))
}

variable "webapp_id" {
  type = list(string)
}

variable "webapp_hostname" {
  type = list(string)
}

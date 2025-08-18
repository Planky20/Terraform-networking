variable "resource_group_name" {
  type        = string
  description = "This defines the name of the resource group"
}

variable "metric_alerts" {
  type = map(object( # Here the KEY will be the name of the alert
    {
      scope            = string
      metric_namespace = string
      metric_name      = string
      aggregation      = string
      operator         = string
      threshold        = string
    }
  ))
}

variable "virtual_machine_details" {
  type = map(object(
    {
      virtual_machine_id = string
    }
  ))
}

variable "resource_group_name" {
  type        = string
  description = "This defines the name of the resource group"
}

variable "location" {
  type        = string
  description = "This defines the location of the resource group and the resources"
}

variable "network_security_group_rules" {
  type = list(object(
    {
      priority               = number
      destination_port_range = string
    }
  ))
  description = "This defines the network security group rules"
}

variable "environment" {
  type = map(object(
    {
      virtual_network_address_space = string
      subnets = map(object(
        {
          subnet_address_prefix = string
          network_interfaces = list(object(
            {
              name                 = string
              virtual_machine_name = string
              script_name          = string
            }
          ))
        }
      ))
    }
  ))
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

variable "firewall_NAT_rules" {
  type = map(object(
    {
      destination_port_number = number
    }
  ))
}

variable "firewall_application_rules" {
  type = map(object(
    {
      allow_url = string
    }
  ))
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

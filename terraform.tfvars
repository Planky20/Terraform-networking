resource_group_name     = "web-rg01"
resource_group_location = "West Europe"

webapp_environment = {
  "uksouthplan10015" = {
    service_plan_os_type  = "Windows"
    service_plan_sku      = "S1"
    service_plan_location = "UK South"
    web_app_name          = "webapp10015wl"
  },
  "northeuropeplan20030" = {
    service_plan_os_type  = "Windows"
    service_plan_sku      = "S1"
    service_plan_location = "North Europe"
    web_app_name          = "webapp20030wl"
  }
}

traffic_manager_endpoints = {
  "primaryendpoint" = {
    priority = 1,
    weight   = 100
  },
  "secondaryendpoint" = {
    priority = 2,
    weight   = 100
  }
}

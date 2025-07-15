resource "azurerm_traffic_manager_profile" "traffic-profile" {
  name                   = "app-profile816751"
  resource_group_name    = var.resource_group_name
  traffic_routing_method = "Priority"

  dns_config {
    relative_name = "app-profile816751"
    ttl           = 100
  }

  monitor_config {
    protocol                     = "HTTPS"
    port                         = 443
    path                         = "/"
    interval_in_seconds          = 30
    timeout_in_seconds           = 9
    tolerated_number_of_failures = 3
  }
}

resource "azurerm_traffic_manager_azure_endpoint" "endpoint" {
  for_each             = var.traffic_manager_endpoints
  name                 = each.key
  profile_id           = azurerm_traffic_manager_profile.traffic-profile.id
  always_serve_enabled = true
  priority             = each.value.priority
  weight               = each.value.weight
  target_resource_id   = var.webapp_id[(each.value.priority) - 1] # We can access each ID via an index number of 0 and 1, this is workaround in this case because first priority has the value of 1 and second has the value of 2

  custom_header {
    name  = "host"
    value = var.webapp_hostname[(each.value.priority) - 1]
  }
}

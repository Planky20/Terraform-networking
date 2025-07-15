resource "azurerm_service_plan" "serviceplan" {
  for_each            = var.webapp_environment
  name                = each.key
  resource_group_name = var.resource_group_name
  location            = each.value.service_plan_location
  os_type             = each.value.service_plan_os_type
  sku_name            = each.value.service_plan_sku
}

resource "azurerm_windows_web_app" "webapp" {
  for_each            = var.webapp_environment
  name                = each.value.web_app_name
  resource_group_name = var.resource_group_name
  location            = each.value.service_plan_location
  service_plan_id     = azurerm_service_plan.serviceplan[each.key].id

  site_config {
    application_stack {
      current_stack  = "dotnet"
      dotnet_version = "v8.0"
    }
  }
}

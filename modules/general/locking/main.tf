data "azurerm_subscription" "current" {
}

resource "azurerm_management_lock" "resource_lock" {
  for_each   = var.resource_list
  name       = "${each.key}-lock"
  scope      = "subscriptions/${data.azurerm_subscription.current.subscription_id}/resourceGroups/${var.resource_group_name}/providers/${each.value.resource_type}/${each.key}"
  lock_level = "CanNotDelete"
  notes      = "Locking resource"
}

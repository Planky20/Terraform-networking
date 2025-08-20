data "azurerm_subscription" "current" {
}

resource "azuread_user" "user" {
  for_each            = var.user_list
  user_principal_name = "${each.key}@${each.value.directory_name}"
  display_name        = each.key
  password            = each.value.password
}

resource "azurerm_role_assignment" "role_assignment" {
  for_each             = var.user_list
  scope                = "subscriptions/${data.azurerm_subscription.current.subscription_id}/resourceGroups/${var.resource_group_name}/providers/${each.value.resource_type}/${each.value.resource_name}"
  role_definition_name = each.value.role
  principal_id         = azuread_user.user[each.key].object_id
}

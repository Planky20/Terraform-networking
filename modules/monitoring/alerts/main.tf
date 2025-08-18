resource "azurerm_monitor_action_group" "email_alert" {
  name                = "email-alert"
  short_name          = "email-alert"
  resource_group_name = var.resource_group_name

  email_receiver {
    name                    = "send-email-alert"
    email_address           = "vlad.lastovskiy@inetum.com"
    use_common_alert_schema = true
  }
}

resource "azurerm_monitor_metric_alert" "metricalerts" {
  for_each            = var.metric_alerts
  name                = each.key
  resource_group_name = var.resource_group_name
  scopes              = [var.virtual_machine_details[each.value.scope].virtual_machine_id]
  description         = "${each.key}-${each.value.metric_name}-${each.value.threshold}"

  criteria {
    metric_namespace = each.value.metric_namespace
    metric_name      = each.value.metric_name
    aggregation      = each.value.aggregation
    operator         = each.value.operator
    threshold        = each.value.threshold
  }

  action {
    action_group_id = azurerm_monitor_action_group.email_alert.id
  }
}

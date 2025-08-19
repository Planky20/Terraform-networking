resource "random_integer" "laworkspace_suffix" {
  min = 4567
  max = 9999
}


resource "azurerm_log_analytics_workspace" "vmworkspace" {
  name                = "vmworkspace${random_integer.laworkspace_suffix.result}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_monitor_data_collection_rule" "windowsRule" {
  name                = "CollectSystemEvents"
  resource_group_name = var.resource_group_name
  location            = var.location

  destinations {
    log_analytics {
      workspace_resource_id = azurerm_log_analytics_workspace.vmworkspace.id
      name                  = "destination-vmworkspace"
    }
  }

  data_flow {
    streams      = ["Microsoft-Event"]
    destinations = ["destination-vmworkspace"]
  }

  data_sources {
    windows_event_log {
      streams        = ["Microsoft-Event"]
      x_path_queries = ["System!*[System[(Level=1 or Level=2 or Level=3 or Level=4 or Level=0 or Level=5)]]"]
      name           = "datasource-wineventlog"
    }
  }
}

resource "azurerm_monitor_data_collection_rule_association" "rule_association" {
  for_each                = var.virtual_machine_details
  name                    = "Windows-Rule-${each.key}"
  target_resource_id      = var.virtual_machine_details[each.key].virtual_machine_id
  data_collection_rule_id = azurerm_monitor_data_collection_rule.windowsRule.id
  description             = "Windows-Rule-${each.key}"
}

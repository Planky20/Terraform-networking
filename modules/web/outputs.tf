output "webapp_id" {
  value = values(azurerm_windows_web_app.webapp)[*].id # Values function takes a map from for_each, and returns a list
}

output "webapp_hostname" {
  value = values(azurerm_windows_web_app.webapp)[*].default_hostname # Values function takes a map from for_each, and returns a list
}

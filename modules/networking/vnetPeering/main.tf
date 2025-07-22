resource "azurerm_virtual_network_peering" "peering-connection" {
  name                      = "${var.source_network_name}-to-${var.destination_vnet_name}"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = var.source_network_name
  remote_virtual_network_id = var.destination_network_id
}

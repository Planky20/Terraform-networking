data "azurerm_network_interface" "networkinterface" {
  for_each            = { for networkinterface in var.network_interface_details : networkinterface.network_interface_name => networkinterface }
  name                = each.key
  resource_group_name = var.resource_group_name
}

resource "azurerm_linux_virtual_machine" "virtualmachines" {
  for_each                        = { for machine in var.virtual_machine_details : machine.virtual_machine_name => machine } # It will construct a map, in which the VM name is the KEY and the entire VM object is the VALUE
  name                            = each.key
  resource_group_name             = var.resource_group_name
  location                        = var.location
  size                            = "Standard_B1s"
  admin_username                  = "linuxadmin"
  admin_password                  = "Azure@123"
  disable_password_authentication = false
  network_interface_ids = [
    data.azurerm_network_interface.networkinterface[each.value.network_interface_name].id
  ]


  lifecycle {
    ignore_changes = [identity]
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

resource "azurerm_virtual_machine_extension" "vmextension" {
  for_each = { for machine in var.virtual_machine_details : machine.virtual_machine_name => machine }
  name = "vmextension"
  virtual_machine_id = azurerm_linux_virtual_machine.virtualmachines[each.key].id
  publisher = "Microsoft.Azure.Extensions"
  type = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
  {
      "fileUris": ["https://${var.storage_account_name}.blob.core.windows.net/${var.container_name}/${each.value.script_name}"],
        "commandToExecute": "sh ${each.value.script_name}"
  }
  SETTINGS
}
data "azurerm_network_interface" "networkinterface" {
  for_each            = { for networkinterface in var.network_interface_details : networkinterface.network_interface_name => networkinterface }
  name                = each.key
  resource_group_name = var.resource_group_name
}

resource "azurerm_windows_virtual_machine" "virtualmachine" {
  for_each            = { for machine in var.virtual_machine_details : machine.virtual_machine_name => machine }
  name                = each.key
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = "Standard_B2s"
  admin_username      = "appadmin"
  admin_password      = "Azure@123"


  lifecycle {
    ignore_changes = [identity]
  }

  network_interface_ids = [
    data.azurerm_network_interface.networkinterface[each.value.network_interface_name].id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }
}

resource "azurerm_virtual_machine_extension" "vmextension" {
  for_each             = { for machine in var.virtual_machine_details : machine.virtual_machine_name => machine }
  name                 = "vmextension"
  virtual_machine_id   = azurerm_windows_virtual_machine.virtualmachine[each.key].id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

  settings = <<SETTINGS
    {
        "fileUris": ["https://${var.storage_account_name}.blob.core.windows.net/${var.container_name}/${each.value.script_name}"],
          "commandToExecute": "powershell -ExecutionPolicy Unrestricted -file ${each.value.script_name}"     
    }
SETTINGS

}
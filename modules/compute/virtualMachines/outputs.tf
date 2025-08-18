output "virtual_machine_details" {
  value = {
    for machine in azurerm_windows_virtual_machine.virtualmachine : # Convert to a map: the machine name will be the KEY and VM id will be the value
    machine.name => (
      {
        virtual_machine_id = machine.id
      }
    )
  }
}

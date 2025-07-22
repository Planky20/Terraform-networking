resource "time_sleep" "wait_180_seconds" { # Required to make sure that nging is already installed before copying the file
  depends_on      = [azurerm_linux_virtual_machine.appvm]
  create_duration = "180s"
}

resource "null_resource" "addfiles" {
  count = var.virtual_machine_count
  provisioner "file" {
    content     = "<h1>This is the web server ${azurerm_linux_virtual_machine.appvm[count.index].computer_name} </h1>"
    destination = "/home/linuxadmin/Default.html"

    connection {
      type     = "ssh"
      user     = "linuxadmin"
      password = "Azure@123"
      host     = var.virtual_machine_public_ip_addresses[count.index]
    }
  }

  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      user     = "linuxadmin"
      password = "Azure@123"
      host     = var.virtual_machine_public_ip_addresses[count.index]
    }
    inline = ["sudo mv /home/linuxadmin/Default.html /var/www/html/Default.html"]
  }
  depends_on = [time_sleep.wait_180_seconds] # remote-exec won't run until 3 minute time will pass
}

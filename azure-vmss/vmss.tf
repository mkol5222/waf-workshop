resource "azurerm_linux_virtual_machine_scale_set" "waf" {
  name                = "waf-tf-vmss-${var.envId}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku                 = local.vmsize         // "Standard_DS2_v2"
  instances           = local.instance_count // 2
  overprovision       = false


  identity {
    type = "SystemAssigned"
  }

  tags = {
    vault = "kvwafvmssdemo6b4d6f7e" // TODO not hardcoded!
  }

  admin_username = "cpadmin"

  admin_password                  = var.admin_password
  disable_password_authentication = false

  source_image_reference {
    publisher = "checkpoint"
    offer     = "infinity-gw"
    sku       = "infinity-img"
    version   = "latest"
  }

  plan {
    publisher = "checkpoint"
    product   = "infinity-gw"
    name      = "infinity-img"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  network_interface {
    name    = "waf-tf-vmss-nic"
    primary = true

    ip_configuration {
      name      = "waf-tf-vmss-ip-config"
      subnet_id = azurerm_subnet.waf.id
      primary   = true

      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.waf.id]
      public_ip_address {
        //sku = "Standard"
        name = "waf-tf-vmss-public-ip"
      }
    }

    network_security_group_id = azurerm_network_security_group.waf.id


  }

  boot_diagnostics {}

  custom_data = base64encode(
    templatefile("${path.module}/custom-data.sh", {
      token = var.waf_token,
      vnet  = local.vnet_address,
      location = local.location,
      bootstrap_script = base64encode(file("${path.module}/bootstrap.sh"))
  }))
}

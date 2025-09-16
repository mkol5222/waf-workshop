
locals {
  rgName         = "waf-workshop-vmss-${var.envId}-rg"
  location       = "North Europe"
  vnet_name      = "waf-workshop-vmss-${var.envId}-vnet"
  vnet_address   = "10.81.0.0/16"
  subnet_name    = "waf-workshop-vmss-${var.envId}-subnet"
  subnet_address = "10.81.1.0/24"
  vmss_name      = "waf-workshop-vmss-${var.envId}-vmss"
  instance_count = 2
  # admin_username = "azureuser"
  admin_password = var.admin_password
  vmsize        = "Standard_DS2_v2"
}

resource "azurerm_resource_group" "main" {
  name     = local.rgName
  location = local.location
}


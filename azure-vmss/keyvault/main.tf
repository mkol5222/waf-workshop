# ----------------------------
# Provider
# ----------------------------
provider "azurerm" {
  features {}

    subscription_id = var.subscriptionId
}

# ----------------------------
# Resource Group
# ----------------------------
resource "azurerm_resource_group" "rg" {
  name     = "rg-vmss-waf-kv=${var.envId}"
  location = "westeurope"
}

data "azurerm_client_config" "current" {}
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.12.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  features {}
  subscription_id = var.subscriptionId
  client_id       = var.appId
  client_secret   = var.password
  tenant_id       = var.tenant
}
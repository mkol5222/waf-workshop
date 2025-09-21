resource "azurerm_key_vault" "kv" {
  name                        = "kvwafvmssdemo${var.envId2}"
  location                    = azurerm_resource_group.rg.location
  resource_group_name         = azurerm_resource_group.rg.name
  sku_name                    = "standard"
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  purge_protection_enabled    = true
  soft_delete_retention_days  = 7
}

output "keyvault_name" {
  value =  "kvwafvmssdemo${var.envId2}"
}

# output "keyvault_uri" {
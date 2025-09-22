resource "azurerm_key_vault_access_policy" "vmss_kv_policy_vmss" {
  key_vault_id = azurerm_key_vault.kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = var.vmss_principal_id
 // azurerm_linux_virtual_machine_scale_set.vmss.identity[0].principal_id
  secret_permissions = ["Get", "List"]
  certificate_permissions = ["Get", "List"]
}

resource "azurerm_key_vault_access_policy" "vmss_kv_policy_sp" {
  key_vault_id = azurerm_key_vault.kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azuread_service_principal.mysp.object_id
 // azurerm_linux_virtual_machine_scale_set.vmss.identity[0].principal_id
  secret_permissions = ["Get", "List"]
  certificate_permissions = ["Get", "List"]
}
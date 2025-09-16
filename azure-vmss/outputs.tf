# vmss system identity
output "vmss_identity" {
  value = azurerm_linux_virtual_machine_scale_set.waf.identity[0].principal_id
}

output "admin_password" {
  value     = local.admin_password
  sensitive = true
}

# output DNS name
output "waf-dns" {
  value = azurerm_public_ip.waf.fqdn
}
# and IP
output "waf-ip" {
  value = azurerm_public_ip.waf.ip_address
}

# cross check
output "admin_password" {
  value     = local.admin_password
  sensitive = true
}
output "waf_token" {
  value     = var.waf_token
  sensitive = true
}
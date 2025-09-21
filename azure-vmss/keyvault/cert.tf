resource "azurerm_key_vault_certificate" "example_cert" {

    depends_on = [ azurerm_key_vault_access_policy.vmss_kv_policy_vmss,
                   azurerm_key_vault_access_policy.vmss_kv_policy_sp
                ]
                
  name         = "my-cert"
  key_vault_id = azurerm_key_vault.kv.id

  certificate_policy {
    issuer_parameters {
      name = "Self"
    }

    key_properties {
      exportable = true
      key_size   = 2048
      key_type   = "RSA"
      reuse_key  = true
    }

    secret_properties {
      content_type = "application/x-pkcs12"
    }

    x509_certificate_properties {
      subject            = "CN=demoaz.local"
      validity_in_months = 12
      key_usage = [
        "digitalSignature",
        "keyEncipherment",
      ]
    }
  }
}

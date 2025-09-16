
resource "azurerm_virtual_network" "waf" {
  name                = local.vnet_name
  address_space       = [local.vnet_address]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_subnet" "waf" {
  name                 = local.subnet_name
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.waf.name
  address_prefixes     = [local.subnet_address]
}

# Create a public IP address
resource "azurerm_public_ip" "waf" {
  name                = "waf-tf-public-ip"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  domain_name_label   = "wafpoc-${random_id.waf.hex}"
}
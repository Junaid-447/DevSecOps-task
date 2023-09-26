resource "azurerm_virtual_network" "vn" {
  name = var.vnet_name
  address_space = var.address_space
  resource_group_name = var.resource_group_name
  location = var.location

tags = var.tags
}

resource "azurerm_network_ddos_protection_plan" "vn_ddos_plan" {
  name                = "devsecops-ddos-plan"
  location            = azurerm_virtual_network.vn.location
  resource_group_name = azurerm_virtual_network.vn.name
}

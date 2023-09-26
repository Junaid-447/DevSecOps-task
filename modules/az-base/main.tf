resource "azurerm_resource_group" "tfstate_rg" {
    name = var.tfstate_resource_group_name
    location = var.location
}
resource "azurerm_storage_account" "tfstate_storage_account" {
    name = var.tfstate_storage_account_name
    location = var.location
    resource_group_name = azurerm_resource_group.tfstate_rg.name
    access_tier = "Standard"
    account_replication_type = "LRS"
}

resource "azurerm_storage_container" "tfstate_container" {
    name = var.tfstate_container
    storage_account_name = azurerm_storage_account.tfstate_storage_account.name
    container_access_type = "private"
}
terraform {
  backend "azurerm" {
    resource_group_name   = var.tfstate_resource_group_name
    storage_account_name  = var.tfstate_storage_account_name
    container_name        = var.tfstate_container
    key                   = "az-k8s.tfstate"
  }
}
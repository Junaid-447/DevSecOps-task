terraform {
  required_version = ">= 0.13"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 3.74.0"
    }
  }
}

provider "azurerm" {
  features {}
# Add credentials for Azure Subscription and Azure Service Principal
#   subscription_id = var.subscription_id
#   tenant_id       = var.tenant_id
#   client_id       = var.client_id
#   client_secret   = var.client_secret
}
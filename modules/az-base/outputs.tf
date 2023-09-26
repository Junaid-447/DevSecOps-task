output "resource_group_id" {
  description = "ID of the Azure resource group"
  value       = azurerm_resource_group.rg.id
}
output "resource_group_name" {
  description = "Name of the Azure resource group"
  value       = azurerm_resource_group.rg.name
}

output "resource_group_location" {
  description = "Location of the Azure resource group"
  value       = azurerm_resource_group.rg.location
}
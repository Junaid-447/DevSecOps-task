output "api_management_id" {
  description = "ID of the API Management service"
  value       = azurerm_api_management.az_apim.id
}

output "api_management_private_ip_address" {
  description = "Private IP address of the API Management service"
  value       = azurerm_api_management.az_apim.private_ip_addresses
}
output "virtual_network_id" {
  description = "ID of the Virtual Network"
  value       = azurerm_virtual_network.vn.id
}
output "virtual_network_name" {
  description = "Name of the Virtual Network"
  value       = azurerm_virtual_network.vn.name
}
output "virtual_network_name_ddos" {
  description = "Name of the Virtual Network"
  value       = azurerm_network_ddos_protection_plan.vn_ddos_plan.id
}
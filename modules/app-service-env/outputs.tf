output "sql_managed_instance_id" {
  description = "ID of the SQL Managed Instance"
  value       = azurerm_sql_managed_instance.az_sql_mi.id
}

output "sql_managed_instance_fqdn" {
  description = "Name the SQL Managed Instance"
  value       = azurerm_sql_managed_instance.az_sql_mi.name
}

output "sql_managed_instance_fqdn" {
  description = "Fully Qualified Domain Name (FQDN) of the SQL Managed Instance"
  value       = azurerm_sql_managed_instance.az_sql_mi.fqdn
}
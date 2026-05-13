output "names" {
  description = "Map of storage account names"
  value       = { for k, v in azurerm_storage_account.storage : k => v.name }
}

output "ids" {
  description = "Map of storage account IDs"
  value       = { for k, v in azurerm_storage_account.storage : k => v.id }
}

output "primary_blob_endpoints" {
  description = "Map of primary blob endpoints"
  value       = { for k, v in azurerm_storage_account.storage : k => v.primary_blob_endpoint }
}

output "primary_web_endpoints" {
  description = "Map of primary web endpoints"
  value       = { for k, v in azurerm_storage_account.storage : k => v.primary_web_endpoint }
}

output "primary_access_keys" {
  description = "Map of primary access keys"
  sensitive   = true
  value       = { for k, v in azurerm_storage_account.storage : k => v.primary_access_key }
}
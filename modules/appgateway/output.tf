output "appgateway_ids" {
  value = { for k, v in azurerm_application_gateway.agw : k => v.id }
}

output "appgateway_names" {
  value = { for k, v in azurerm_application_gateway.agw : k => v.name }
}

output "frontend_private_ips" {
  value = {
    for k, v in azurerm_application_gateway.agw :
    k => v.frontend_ip_configuration[0].private_ip_address
  }
}
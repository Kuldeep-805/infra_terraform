output "lb_ids" {
  value = { for k, v in azurerm_lb.lb : k => v.id }
}

output "lb_names" {
  value = { for k, v in azurerm_lb.lb : k => v.name }
}

output "frontend_private_ips" {
  value = {
    for k, v in azurerm_lb.lb :
    k => try(v.frontend_ip_configuration[0].private_ip_address, null)
  }
}

output "public_ips" {
  value = {
    for k, v in azurerm_public_ip.pip :
    k => v.ip_address
  }
}
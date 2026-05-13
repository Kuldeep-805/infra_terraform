resource "azurerm_application_gateway" "agw" {
  for_each = var.appgateways

  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name

  sku {
    name     = each.value.sku_name
    tier     = each.value.sku_tier
    capacity = each.value.capacity
  }

  gateway_ip_configuration {
    name      = "gateway-ip-config"
    subnet_id = each.value.subnet_id
  }

  frontend_port {
    name = "frontend-port"
    port = each.value.frontend_port
  }

  frontend_ip_configuration {
    name                 = "frontend-ip-config"
    private_ip_address   = each.value.private_ip_address
    private_ip_address_allocation = "Static"
    subnet_id            = each.value.subnet_id
  }

  backend_address_pool {
    name         = "backend-pool"
    ip_addresses = each.value.backend_ips
  }

  backend_http_settings {
    name                  = "backend-setting"
    cookie_based_affinity = "Disabled"
    port                  = each.value.backend_port
    protocol              = "Http"
    request_timeout       = 30
  }

  http_listener {
    name                           = "listener"
    frontend_ip_configuration_name = "frontend-ip-config"
    frontend_port_name             = "frontend-port"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "rule1"
    rule_type                  = "Basic"
    http_listener_name         = "listener"
    backend_address_pool_name  = "backend-pool"
    backend_http_settings_name = "backend-setting"
    priority                   = 100
  }

  tags = merge(
    var.common_tags,
    coalesce(each.value.tags, {})
  )
}
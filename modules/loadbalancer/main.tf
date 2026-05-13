# Public IP (only if external LB)
resource "azurerm_public_ip" "pip" {
  for_each = {
    for k, v in var.loadbalancers : k => v
    if try(v.is_public, false)
  }

  name                = "${each.value.name}-pip"
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = merge(var.common_tags, coalesce(each.value.tags, {}))
}

# Load Balancer
resource "azurerm_lb" "lb" {
  for_each = var.loadbalancers

  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  sku                 = "Standard"

  frontend_ip_configuration {
    name = "frontend-ip"

    subnet_id = try(each.value.is_public, false) ? null : each.value.subnet_id

    private_ip_address_allocation = try(each.value.is_public, false) ? null : "Static"
    private_ip_address            = try(each.value.is_public, false) ? null : each.value.private_ip_address

    public_ip_address_id = try(each.value.is_public, false) ? azurerm_public_ip.pip[each.key].id : null
  }

  tags = merge(var.common_tags, coalesce(each.value.tags, {}))
}

# Backend Pool
resource "azurerm_lb_backend_address_pool" "bepool" {
  for_each = var.loadbalancers

  name            = "${each.value.name}-bepool"
  loadbalancer_id = azurerm_lb.lb[each.key].id
}

# Health Probe
resource "azurerm_lb_probe" "probe" {
  for_each = var.loadbalancers

  name            = "${each.value.name}-probe"
  loadbalancer_id = azurerm_lb.lb[each.key].id
  protocol        = "Tcp"
  port            = each.value.backend_port
}

# LB Rule
resource "azurerm_lb_rule" "rule" {
  for_each = var.loadbalancers

  name                           = "${each.value.name}-rule"
  loadbalancer_id                = azurerm_lb.lb[each.key].id
  protocol                       = "Tcp"
  frontend_port                  = each.value.frontend_port
  backend_port                   = each.value.backend_port
  frontend_ip_configuration_name = "frontend-ip"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.bepool[each.key].id]
  probe_id                       = azurerm_lb_probe.probe[each.key].id
}
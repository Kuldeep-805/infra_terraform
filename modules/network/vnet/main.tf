# ==============================
# VNET
# ==============================
resource "azurerm_virtual_network" "vnet" {
  for_each = var.vnets

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  address_space       = each.value.address_space

  tags = merge(var.common_tags, coalesce(each.value.tags, {}))
}

# ==============================
# SUBNET (FIXED)
# ==============================
resource "azurerm_subnet" "subnet" {

  depends_on = [
    azurerm_virtual_network.vnet
  ]
  
  for_each = merge([
    for vnet_key, vnet in var.vnets : {
      for subnet_key, subnet in vnet.subnets :
      "${vnet_key}-${subnet_key}" => {
        vnet_name           = vnet.name
        resource_group_name = vnet.resource_group_name
        name                = subnet.name
        address_prefixes    = subnet.address_prefixes
      }
    }
  ]...)

  name                 = each.value.name
  resource_group_name  = each.value.resource_group_name
  virtual_network_name = each.value.vnet_name
  address_prefixes     = each.value.address_prefixes
}
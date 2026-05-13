resource "azurerm_resource_group" "rg" {
  for_each = var.resource_groups

  name     = each.value.name
  location = each.value.location

  tags = merge(
    var.common_tags,
    try(each.value.tags, {})
  )

  managed_by = try(each.value.managed_by, null)
}
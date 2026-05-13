# ==============================
# Network Interface
# ==============================
resource "azurerm_network_interface" "nic" {
  for_each = var.vms

  name                = "${each.value.name}-nic"
  location            = each.value.location
  resource_group_name = each.value.resource_group_name

  accelerated_networking_enabled = try(each.value.accelerated_networking, false)

  ip_configuration {
    name                          = "internal"
    subnet_id                     = each.value.subnet_id
    private_ip_address_allocation = try(each.value.private_ip_address, null) != null ? "Static" : "Dynamic"
    private_ip_address            = try(each.value.private_ip_address, null)
  }

  tags = merge(var.common_tags, coalesce(each.value.tags, {}))
}

# ==============================
# Windows Virtual Machine
# ==============================
resource "azurerm_windows_virtual_machine" "vm" {
  for_each = var.vms

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  size                = each.value.size

  admin_username = each.value.admin_username
  admin_password = each.value.admin_password   # Required for Windows

  network_interface_ids = [
    azurerm_network_interface.nic[each.key].id
  ]

  computer_name = substr(replace(each.value.name, "-", ""), 0, 15)

  # ✅ FIXED
  custom_data = try(each.value.custom_data, null) != null ? base64encode(each.value.custom_data) : null

  zone                = try(each.value.availability_zone, null)
  availability_set_id = try(each.value.availability_set_id, null)

  encryption_at_host_enabled = try(each.value.encryption_at_host_enabled, false)
  secure_boot_enabled        = try(each.value.secure_boot_enabled, true)
  vtpm_enabled               = try(each.value.vtpm_enabled, true)

  os_disk {
    name                 = "${each.value.name}-osdisk"
    caching              = try(each.value.os_disk.caching, "ReadWrite")
    storage_account_type = try(each.value.os_disk.storage_account_type, "Premium_LRS")
    disk_size_gb         = try(each.value.os_disk.disk_size_gb, null)
  }

  source_image_reference {
    publisher = try(each.value.source_image_reference.publisher, "MicrosoftWindowsServer")
    offer     = try(each.value.source_image_reference.offer, "WindowsServer")
    sku       = try(each.value.source_image_reference.sku, "2022-datacenter-azure-edition")
    version   = try(each.value.source_image_reference.version, "latest")
  }

  tags = merge(var.common_tags, coalesce(each.value.tags, {}))
}
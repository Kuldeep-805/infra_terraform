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
# Linux Virtual Machine
# ==============================
resource "azurerm_linux_virtual_machine" "vm" {
  for_each = var.vms

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  size                = each.value.size

  admin_username = each.value.admin_username

  # ==============================
  # Authentication
  # ==============================
  disable_password_authentication = coalesce(each.value.disable_password_authentication, true)

  admin_password = coalesce(each.value.disable_password_authentication, true) ? null : each.value.admin_password

  dynamic "admin_ssh_key" {
    for_each = coalesce(each.value.admin_ssh_key, [])
    content {
      username   = admin_ssh_key.value.username
      public_key = admin_ssh_key.value.public_key
    }
  }

  # ==============================
  # Networking
  # ==============================
  network_interface_ids = [
    azurerm_network_interface.nic[each.key].id
  ]

  computer_name = substr(replace(each.value.name, "-", ""), 0, 64)

  # ==============================
  # Custom Data (cloud-init)
  # ==============================
  custom_data = try(each.value.custom_data, null) != null ? base64encode(each.value.custom_data) : null

  # ==============================
  # Availability
  # ==============================
  zone                = try(each.value.availability_zone, null)
  availability_set_id = try(each.value.availability_set_id, null)

  # ==============================
  # Security
  # ==============================
  encryption_at_host_enabled = try(each.value.encryption_at_host_enabled, false)
  secure_boot_enabled        = false
  vtpm_enabled               = false

  # ==============================
  # OS Disk (SAFE)
  # ==============================
  os_disk {
    name                 = "${each.value.name}-osdisk"
    caching              = try(each.value.os_disk.caching, "ReadWrite")
    storage_account_type = try(each.value.os_disk.storage_account_type, "Premium_LRS")
    disk_size_gb         = try(each.value.os_disk.disk_size_gb, null)
  }

  # ==============================
  # Image
  # ==============================
  source_image_reference {
    publisher = try(each.value.source_image_reference.publisher, "Canonical")
    offer     = try(each.value.source_image_reference.offer, "0001-com-ubuntu-server-jammy")
    sku       = try(each.value.source_image_reference.sku, "22_04-lts")
    version   = try(each.value.source_image_reference.version, "latest")
  }

  # ==============================
  # Tags
  # ==============================
  tags = merge(var.common_tags, coalesce(each.value.tags, {}))
}
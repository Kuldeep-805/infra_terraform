variable "vms" {
  description = "Map of Linux VM configurations"

  type = map(object({
    name                = string
    resource_group_name = string
    location            = string
    size                = string
    subnet_id           = string
    admin_username      = string

    # Auth
    admin_password                  = optional(string)
    disable_password_authentication = optional(bool, true)

    admin_ssh_key = optional(list(object({
      username   = string
      public_key = string
    })), [])

    # Networking
    private_ip_address        = optional(string)
    accelerated_networking    = optional(bool, false)

    # Cloud-init
    custom_data = optional(string)

    # Availability
    availability_zone    = optional(string)
    availability_set_id  = optional(string)

    # Security
    encryption_at_host_enabled = optional(bool, false)
    secure_boot_enabled        = optional(bool, true)
    vtpm_enabled               = optional(bool, true)

    # OS Disk
    os_disk = optional(object({
      caching              = optional(string, "ReadWrite")
      storage_account_type = optional(string, "Premium_LRS")
      disk_size_gb         = optional(number)
    }), {})

    # Image
    source_image_reference = optional(object({
      publisher = string
      offer     = string
      sku       = string
      version   = optional(string, "latest")
    }), {
      publisher = "Canonical"
      offer     = "0001-com-ubuntu-server-jammy"
      sku       = "22_04-lts"
      version   = "latest"
    })

    # Tags
    tags = optional(map(string), {})
  }))

  # ✅ VALIDATION (VERY IMPORTANT)
  validation {
    condition = alltrue([
      for vm in values(var.vms) :
      (
        # Either password OR SSH must be provided
        (
          (vm.disable_password_authentication == false && vm.admin_password != null) ||
          length(vm.admin_ssh_key) > 0
        )
      )
    ])
    error_message = "Each VM must have either admin_password (when password auth enabled) OR admin_ssh_key defined."
  }
}

# Common Tags
variable "common_tags" {
  description = "Common tags applied to all resources"
  type        = map(string)
  default     = {}
}
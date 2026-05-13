variable "vms" {
  description = "Map of Windows VM configurations"
  type = map(object({
    name                = string
    resource_group_name = string
    location            = string
    size                = string
    subnet_id           = string

    admin_username = string
    admin_password = string   # Mandatory for Windows

    private_ip_address       = optional(string)
    accelerated_networking   = optional(bool, false)

    custom_data = optional(string)

    availability_zone    = optional(string)
    availability_set_id  = optional(string)

    encryption_at_host_enabled = optional(bool)
    secure_boot_enabled        = optional(bool)
    vtpm_enabled               = optional(bool)

    os_disk = optional(object({
      caching              = optional(string, "ReadWrite")
      storage_account_type = optional(string, "Premium_LRS")
      disk_size_gb         = optional(number)
    }), {})

    source_image_reference = optional(object({
      publisher = string
      offer     = string
      sku       = string
      version   = optional(string, "latest")
    }), {
      publisher = "MicrosoftWindowsServer"
      offer     = "WindowsServer"
      sku       = "2022-datacenter-azure-edition"
      version   = "latest"
    })

    tags = optional(map(string), {})
  }))
}

variable "common_tags" {
  type    = map(string)
  default = {}
}
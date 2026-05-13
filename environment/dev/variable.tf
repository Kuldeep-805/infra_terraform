# ==============================
# Common Tags (ONLY ONCE)
# ==============================
variable "common_tags" {
  description = "Common tags applied to all resources"
  type        = map(string)
  default     = {}
}

# ==============================
# Resource Groups
# ==============================
variable "resource_groups" {
  description = "Map of resource group configurations"

  type = map(object({
    name       = string
    location   = string
    tags       = optional(map(string), {})
    managed_by = optional(string)
  }))
}

# ==============================
# Storage Accounts
# ==============================
variable "storage_accounts" {
  description = "Map of Storage Account configurations"

  type = map(object({
    name                = string
    resource_group_name = string
    location            = string

    account_tier             = string
    account_replication_type = string

    account_kind    = optional(string, "StorageV2")
    access_tier     = optional(string, "Hot")
    min_tls_version = optional(string, "TLS1_2")

    public_network_access_enabled = optional(bool, true)

    tags = optional(map(string), {})
  }))
}

# ==============================
# VNets
# ==============================
variable "vnets" {
  description = "Map of VNets with subnets"

  type = map(object({
    name                = string
    resource_group_name = string
    location            = string
    address_space       = list(string)

    tags = optional(map(string), {})

    subnets = map(object({
      name             = string
      address_prefixes = list(string)
    }))
  }))
}

# ==============================
# Linux VMs
# ==============================
variable "linux_vms" {
  description = "Map of Linux VM configurations"

  type = map(object({
    name                = string
    resource_group_name = string
    location            = string
    size                = string
    subnet_id           = string
    admin_username      = string

    admin_password                  = optional(string)
    disable_password_authentication = optional(bool, true)

    admin_ssh_key = optional(list(object({
      username   = string
      public_key = string
    })), [])

    private_ip_address     = optional(string)
    accelerated_networking = optional(bool, false)

    custom_data = optional(string)

    availability_zone   = optional(string)
    availability_set_id = optional(string)

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
      publisher = "Canonical"
      offer     = "0001-com-ubuntu-server-jammy"
      sku       = "22_04-lts"
      version   = "latest"
    })

    tags = optional(map(string), {})
  }))
}

# ==============================
# Windows VMs
# ==============================
variable "windows_vms" {
  description = "Map of Windows VM configurations"

  type = map(object({
    name                = string
    resource_group_name = string
    location            = string
    size                = string
    subnet_id           = string

    admin_username = string
    admin_password = string

    private_ip_address     = optional(string)
    accelerated_networking = optional(bool, false)

    custom_data = optional(string)

    availability_zone   = optional(string)
    availability_set_id = optional(string)

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

# ==============================
# Load Balancers
# ==============================
variable "loadbalancers" {
  description = "Map of Load Balancer configurations"

  type = map(object({
    name                = string
    resource_group_name = string
    location            = string

    is_public = optional(bool, false)

    subnet_id          = optional(string)
    private_ip_address = optional(string)

    frontend_port = number
    backend_port  = number

    tags = optional(map(string), {})
  }))
}

# ==============================
# Key Vaults
# ==============================
variable "key_vaults" {
  description = "Map of Key Vault configurations"

  type = map(object({
    name                = string
    resource_group_name = string
    location            = string

    sku_name = optional(string, "standard")

    enabled_for_disk_encryption     = optional(bool, false)
    enabled_for_deployment          = optional(bool, false)
    enabled_for_template_deployment = optional(bool, false)

    enable_rbac_authorization = optional(bool, true)

    soft_delete_retention_days = optional(number, 90)
    purge_protection_enabled   = optional(bool, true)

    public_network_access_enabled = optional(bool, false)

    tags = optional(map(string), {})
  }))
}


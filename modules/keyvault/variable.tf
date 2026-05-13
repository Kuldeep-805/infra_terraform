variable "key_vaults" {
  description = "Map of Key Vault configurations"
  type = map(object({
    name                = string
    resource_group_name = string
    location            = string

    sku_name = optional(string, "standard")

    enabled_for_disk_encryption        = optional(bool, false)
    enabled_for_deployment             = optional(bool, false)
    enabled_for_template_deployment    = optional(bool, false)

    enable_rbac_authorization = optional(bool, true)

    soft_delete_retention_days = optional(number, 90)
    purge_protection_enabled   = optional(bool, true)

    public_network_access_enabled = optional(bool, false)

    tags = optional(map(string), {})
  }))
}

variable "common_tags" {
  type    = map(string)
  default = {}
}
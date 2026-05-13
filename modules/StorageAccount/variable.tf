variable "storage_accounts" {
  description = "Map of storage accounts"

  type = map(object({
    name                     = string
    resource_group_name      = string
    location                 = string
    account_tier             = string
    account_replication_type = string
    tags                     = optional(map(string))
  }))
}

variable "common_tags" {
  description = "Common tags"

  type = map(string)

  default = {}
}
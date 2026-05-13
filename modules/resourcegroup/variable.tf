variable "resource_groups" {
  description = "Map of resource group configurations. Keys are logical names."

  type = map(object({
    name        = string
    location    = string
    tags        = optional(map(string), {})
    managed_by  = optional(string)
  }))
}

variable "common_tags" {
  description = "Common tags applied to all resources"
  type        = map(string)
  default     = {}
}
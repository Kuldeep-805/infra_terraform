variable "appgateways" {
  description = "Map of Application Gateway configurations"
  type = map(object({
    name                = string
    resource_group_name = string
    location            = string

    subnet_id = string

    # SKU
    sku_name = optional(string, "Standard_v2")
    sku_tier = optional(string, "Standard_v2")
    capacity = optional(number, 1)

    # Frontend
    frontend_port      = optional(number, 80)
    private_ip_address = string

    # Backend
    backend_ips  = list(string)
    backend_port = optional(number, 80)

    tags = optional(map(string), {})
  }))
}

variable "common_tags" {
  type    = map(string)
  default = {}
}
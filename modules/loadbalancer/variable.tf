variable "loadbalancers" {
  description = "Map of Load Balancer configurations"
  type = map(object({
    name                = string
    resource_group_name = string
    location            = string

    # Internal / External
    is_public = optional(bool, false)

    # Internal LB
    subnet_id          = optional(string)
    private_ip_address = optional(string)

    # Ports
    frontend_port = number
    backend_port  = number

    tags = optional(map(string), {})
  }))
}

variable "common_tags" {
  type    = map(string)
  default = {}
}
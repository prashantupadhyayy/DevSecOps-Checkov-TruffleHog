variable "var_child_public_ip" {
  type = map(object({
    # Public IP resource block required arguments
    location            = string
    resource_group_name = string
    public_ip_name      = string
    allocation_method   = string

    # Public IP resource block optional arguments
    zones                   = optional(list(string))
    ddos_protection_mode    = optional(string) # Disabled, Enabled, or VirtualNetworkInherited
    ddos_protection_plan_id = optional(string)
    domain_name_label       = optional(string)
    domain_name_label_scope = optional(string) # NoReuse, ResourceGroupReuse, SubscriptionReuse, TenantReuse
    public_ip_edge_zone     = optional(string)
    idle_timeout_in_minutes = optional(number)
    ip_tags                 = optional(map(string))
    ip_version              = optional(string) # IPv4 or IPv6
    public_ip_prefix_id     = optional(string)
    reverse_fqdn            = optional(string)
    sku                     = optional(string) # Basic or Standard
    sku_tier                = optional(string) # Regional or Global
    public_ip_tags          = optional(map(string))
  }))
}

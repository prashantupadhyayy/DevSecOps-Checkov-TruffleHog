variable "var_root_dev_resource_group" {
  type = map(object(
    {
      resource_group_name = string
      location            = string
      tags                = optional(map(string))
    }
  ))
}

variable "var_root_dev_vnet" {
  description = "Map of Virtual Network, Subnet, Public IP"
  type = map(object({
    # Virtual Network resource block arguments
    vnet_name                      = string
    location                       = string
    resource_group_name            = string
    address_space                  = optional(list(string))
    dns_servers                    = optional(list(string))
    bgp_community                  = optional(string)
    vnet_edge_zone                 = optional(string)
    flow_timeout_in_minutes        = optional(number)
    private_endpoint_vnet_policies = optional(string)
    vnet_tags                      = optional(map(string))

    # Optional: DDoS Protection Plan block
    ddos_protection_plan = optional(object({
      id     = string
      enable = bool
    }))

    # Optional: Encryption block
    encryption = optional(object({
      enforcement = string
    }))

    # Optional: IP Address Pool block
    ip_address_pool = optional(map(object({
      id                     = string
      number_of_ip_addresses = string
    })))
  }))
}

variable "var_root_dev_subnet" {
  description = "Subnet definitions for each VNet"
  type = map(object({
    subnet_name          = string
    resource_group_name  = string
    virtual_network_name = string # Links this subnet to the VNet map key

    address_prefixes = optional(list(string))
    ip_address_pool = optional(object({
      id                     = string
      number_of_ip_addresses = string
    }))
    default_outbound_access_enabled               = optional(bool, true)
    private_endpoint_network_policies             = optional(string)
    private_link_service_network_policies_enabled = optional(bool, true)
    sharing_scope                                 = optional(string)
    service_endpoints                             = optional(list(string))
    service_endpoint_policy_ids                   = optional(list(string))
    delegation = optional(list(object({
      name = string
      service_delegation = object({
        name    = string
        actions = optional(list(string))
      })
    })))
  }))
}

variable "var_root_dev_public_ip" {
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

variable "var_root_dev_nsg" {
  description = "Map of Network Security Groups to create with optional security rules."
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    tags                = optional(map(string))

    security_rules = optional(list(object({
      name                                       = string
      description                                = optional(string)
      protocol                                   = string
      source_port_range                          = optional(string)
      source_port_ranges                         = optional(list(string))
      destination_port_range                     = optional(string)
      destination_port_ranges                    = optional(list(string))
      source_address_prefix                      = optional(string)
      source_address_prefixes                    = optional(list(string))
      destination_address_prefix                 = optional(string)
      destination_address_prefixes               = optional(list(string))
      source_application_security_group_ids      = optional(list(string))
      destination_application_security_group_ids = optional(list(string))
      access                                     = string
      priority                                   = number
      direction                                  = string
    })))
  }))
}


variable "var_root_dev_nic" {
  description = "Map of Network Interfaces with their IP configuration details."
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string

    auxiliary_mode                 = optional(string)
    auxiliary_sku                  = optional(string)
    dns_servers                    = optional(list(string))
    edge_zone                      = optional(string)
    ip_forwarding_enabled          = optional(bool)
    accelerated_networking_enabled = optional(bool)
    internal_dns_name_label        = optional(string)
    tags                           = optional(map(string))

    ip_configurations = list(object({
      name                                               = string
      subnet_id                                          = optional(string)
      private_ip_address_version                         = optional(string)
      private_ip_address_allocation                      = string
      private_ip_address                                 = optional(string)
      public_ip_address_id                               = optional(string)
      primary                                            = optional(bool)
      gateway_load_balancer_frontend_ip_configuration_id = optional(string)
    }))

    # Required values for data block of subnet
    subnet_name          = string
    virtual_network_name = string
    subnet_key           = string

    # Required values for data block of public ip address
    public_ip_name = string

    # Required values for data block of nsg
    nsg_key = optional(string)
  }))
}


variable "var_root_dev_vms" {
  description = "Map of virtual machines with configuration"
  type = map(object({
    name                        = string
    location                    = string
    resource_group_name          = string
    size                         = string
    admin_username_key               = optional(string)
    admin_password_key               = optional(string)
    disable_password_authentication = bool
    # network_interface_id         = string
    nic_name = string
    storage_account_type         = string
    
    image = object({
      publisher = string
      offer     = string
      sku       = string
      version   = string
    })
    
    ssh_public_key          = optional(string)
    computer_name           = string
    boot_diag_storage_uri   = optional(string)
    tags                    = optional(map(string))

    # Key Vault variables
    key_Vault_name      = string
    key_Vault_resource_group_name = string
    # key_vm_username = string
    # key_vm_password = string
  }))
}

variable "var_root_dev_sql_server" {
  type = map(object(
    {
      sql_server_name               = string
      resource_group_name           = string
      location                      = string
      sql_server_version            = string
      minimum_tls_version           = string
      public_network_access_enabled = bool
      identity_type                 = string

      # Key Vault variables
      key_Vault_name                = string
      key_Vault_resource_group_name = string

      sql_username_key = optional(string)
      sql_password_key = optional(string)

      # # Will be called using Azure Key Vault
      # administrator_login = string
      # administrator_login_password = string
    }
  ))
}


variable "var_root_dev_mssql_databases" {
  description = "Map of MSSQL Databases to be created"
  type = map(object(
    {
      name                                = string
      server_id                           = optional(string)
      collation                           = optional(string)
      elastic_pool_id                     = optional(string)
      sku_name                            = optional(string)
      max_size_gb                         = optional(number)
      license_type                        = optional(string)
      geo_backup_enabled                  = optional(bool)
      read_scale                          = optional(bool)
      zone_redundant                      = optional(bool)
      ledger_enabled                      = optional(bool)
      auto_pause_delay_in_minutes         = optional(number)
      min_capacity                        = optional(number)
      create_mode                         = optional(string)
      transparent_data_encryption_enabled = optional(bool)
      maintenance_configuration_name      = optional(string)
      tags                                = optional(map(string))

      threat_detection_policy = optional(object({
        state                      = optional(string)
        email_account_admins       = optional(string)
        email_addresses            = optional(list(string))
        retention_days             = optional(number)
        storage_endpoint           = optional(string)
        storage_account_access_key = optional(string)
      }))

      identity = optional(object({
        type         = string
        identity_ids = list(string)
      }))

      short_term_retention_policy = optional(object({
        retention_days           = number
        backup_interval_in_hours = optional(number)
      }))

      long_term_retention_policy = optional(object({
        weekly_retention  = optional(string)
        monthly_retention = optional(string)
        yearly_retention  = optional(string)
        week_of_year      = optional(number)
      }))

      sql_server_name = string
resource_group_name = string
    }
  ))
}
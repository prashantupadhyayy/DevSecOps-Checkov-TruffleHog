variable "var_child_sql_server" {
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

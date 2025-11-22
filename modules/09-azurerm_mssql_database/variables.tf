variable "var_child_mssql_databases" {
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
      resource_group_name           = string
    }
  ))
}

# resource "azurerm_mssql_database" "child_sql_database" {
#   name         = var.child_sql_database_name
#   server_id    = data.azurerm_mssql_server.get_child_sql_server.id
#   collation    = "SQL_Latin1_General_CP1_CI_AS"
#   license_type = "LicenseIncluded"
#   max_size_gb  = 2 # Size in GB
#   sku_name     = "S0"
#   enclave_type = "VBS"
# }


resource "azurerm_mssql_database" "child_db" {
  for_each = var.var_child_mssql_databases

  name                = each.value.name
  server_id           = data.azurerm_mssql_server.get_child_sql_server[each.key].id
  collation           = lookup(each.value, "collation", null)
  elastic_pool_id     = lookup(each.value, "elastic_pool_id", null)
  sku_name            = lookup(each.value, "sku_name", "GP_S_Gen5_2")
  max_size_gb         = lookup(each.value, "max_size_gb", 5)
  license_type        = lookup(each.value, "license_type", null)
  geo_backup_enabled  = lookup(each.value, "geo_backup_enabled", true)
  read_scale          = lookup(each.value, "read_scale", null)
  zone_redundant      = lookup(each.value, "zone_redundant", null)
  ledger_enabled      = lookup(each.value, "ledger_enabled", false)
  auto_pause_delay_in_minutes = lookup(each.value, "auto_pause_delay_in_minutes", null)
  min_capacity        = lookup(each.value, "min_capacity", null)
  create_mode         = lookup(each.value, "create_mode", "Default")

  transparent_data_encryption_enabled = lookup(each.value, "transparent_data_encryption_enabled", true)
  maintenance_configuration_name      = lookup(each.value, "maintenance_configuration_name", "SQL_Default")

  tags = try(each.value.tags, {})

  # Optional Threat Detection Policy
  dynamic "threat_detection_policy" {
    for_each = lookup(each.value, "threat_detection_policy", null) == null ? [] : [each.value.threat_detection_policy]
    content {
      state                    = lookup(threat_detection_policy.value, "state", "Disabled")
      email_account_admins     = lookup(threat_detection_policy.value, "email_account_admins", "Disabled")
      email_addresses          = lookup(threat_detection_policy.value, "email_addresses", [])
      retention_days           = lookup(threat_detection_policy.value, "retention_days", null)
      storage_endpoint         = lookup(threat_detection_policy.value, "storage_endpoint", null)
      storage_account_access_key = lookup(threat_detection_policy.value, "storage_account_access_key", null)
    }
  }

  # Optional Identity
  dynamic "identity" {
    for_each = lookup(each.value, "identity", null) == null ? [] : [each.value.identity]
    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  # Optional Short-term Retention Policy
  dynamic "short_term_retention_policy" {
    for_each = lookup(each.value, "short_term_retention_policy", null) == null ? [] : [each.value.short_term_retention_policy]
    content {
      retention_days            = short_term_retention_policy.value.retention_days
      backup_interval_in_hours  = lookup(short_term_retention_policy.value, "backup_interval_in_hours", 12)
    }
  }

  # Optional Long-term Retention Policy
  dynamic "long_term_retention_policy" {
    for_each = lookup(each.value, "long_term_retention_policy", null) == null ? [] : [each.value.long_term_retention_policy]
    content {
      weekly_retention  = lookup(long_term_retention_policy.value, "weekly_retention", null)
      monthly_retention = lookup(long_term_retention_policy.value, "monthly_retention", null)
      yearly_retention  = lookup(long_term_retention_policy.value, "yearly_retention", null)
      week_of_year      = lookup(long_term_retention_policy.value, "week_of_year", null)
    }
  }
}
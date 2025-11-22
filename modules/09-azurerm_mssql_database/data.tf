data "azurerm_mssql_server" "get_child_sql_server" {
  for_each = var.var_child_mssql_databases
  
  name                = each.value.sql_server_name
  resource_group_name = each.value.resource_group_name
}


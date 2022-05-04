resource "azurerm_resource_group" "simpleapp" {
  name     = var.rgname
  location = var.location
}

resource "azurerm_service_plan" "simpleappplan" {
  name                = var.serviceplan
  location            = azurerm_resource_group.simpleapp.location
  resource_group_name = azurerm_resource_group.simpleapp.name
  os_type                = "Linux"
 # reserved            = true
  
  sku_name= "S1"
  
}
/*
resource "azurerm_mssql_server" "mssqlserver" {
  name                = var.mssqlname
  location            = azurerm_resource_group.simpleapp.location
  resource_group_name = azurerm_resource_group.simpleapp.name
  administrator_login          = var.username
  administrator_login_password = var.password
  version    = "12.0"
} */
resource "azurerm_linux_web_app" "simpleappser" {
  name                = var.service
  location            = azurerm_resource_group.simpleapp.location
  resource_group_name = azurerm_resource_group.simpleapp.name
  service_plan_id = azurerm_service_plan.simpleappplan.id
  https_only = true
  site_config {}

  app_settings = {
    FUNCTIONS_WORKER_RUNTIME = "python"
  }
  connection_string {
    name  = "appserver"
    type  = "SQLServer"
    value = "Server=azurerm_mssql_server.mssqlserver.database.linux.net;Integrated Security=SSPI"
  }

}
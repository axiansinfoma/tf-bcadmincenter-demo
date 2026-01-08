resource "bcadmincenter_environment" "dev" {
  name               = "dev"
  type               = "Sandbox"
  country_code       = "US"
  application_family = "BusinessCentral"
}

resource "bcadmincenter_environment_settings" "dev" {
  application_family = "BusinessCentral"
  environment_name   = bcadmincenter_environment.dev.name

  app_insights_key = azurerm_application_insights.appi.connection_string

  update_window_start_time = "22:00"
  update_window_end_time   = "06:00"
  update_window_timezone   = "UTC"
}
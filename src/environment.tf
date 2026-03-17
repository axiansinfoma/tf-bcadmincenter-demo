data "bcadmincenter_application_family" "business_central" {
  name = "BusinessCentral"
}

resource "bcadmincenter_environment" "example" {
  name               = "demo_mivi"
  country_code       = "DE"
  type               = "Sandbox"
  application_family = data.bcadmincenter_application_family.business_central.name

  settings {
    update_window_start_time = "22:00"
    update_window_end_time   = "04:00"
    update_window_timezone   = "W. Europe Standard Time"
  }
}

data "bcadmincenter_application_family" "business_central" {
  name = "BusinessCentral"
}

resource "bcadmincenter_environment" "example" {
  name               = "demo_mivi"
  country_code       = "DE"
  type               = "Sandbox"
  application_family = data.bcadmincenter_application_family.business_central.name
}

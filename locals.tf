# Local values

locals {
  # Service catalog - maps service keys to SAP BTP service details
  service_catalog = {
    cf_runtime = {
      service_name = "APPLICATION_RUNTIME"
      plan_name    = "MEMORY"
      amount       = 1
    }
    hana_cloud = {
      service_name = "hana-cloud"
      plan_name    = "hana"
      amount       = null
    }
    connectivity = {
      service_name = "connectivity"
      plan_name    = "lite"
      amount       = null
    }
    bas = {
      service_name = "sapappstudio"
      plan_name    = "standard-edition"
      amount       = null
    }
    workzone = {
      service_name = "SAPLaunchpad"
      plan_name    = "standard"
      amount       = null
    }
    aicore = {
      service_name = "aicore"
      plan_name    = "extended"
      amount       = null
    }
  }

  # Filter to only services that exist in the catalog
  enabled_services = {
    for svc in var.additional_services : svc => local.service_catalog[svc]
    if contains(keys(local.service_catalog), svc)
  }
}

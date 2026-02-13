# =============================================================================
# SAP BTP + TERRAFORM DEMO — Multi-Customer Onboarding
# =============================================================================
#
# One apply. Multiple customers. Each gets their own isolated subaccount
# with services tailored to their needs.
#
# Manual setup: 2-4 hours PER customer
# With Terraform: ALL customers in ~2 minutes
#
# =============================================================================

# -----------------------------------------------------------------------------
# DATA SOURCES
# -----------------------------------------------------------------------------

data "btp_globalaccount" "this" {}

# -----------------------------------------------------------------------------
# STEP 1: Create Customer Subaccounts
# -----------------------------------------------------------------------------

resource "btp_subaccount" "customer" {
  for_each = var.customers

  name        = "${each.value.name} Portal"
  subdomain   = "${each.key}-portal-${formatdate("YYYYMMDDhhmmss", timestamp())}"
  region      = var.region
  description = "Customer environment for ${each.value.name} - created by Terraform"

  labels = {
    "managed-by"  = ["terraform"]
    "environment" = ["demo"]
    "customer"    = [each.key]
  }

  lifecycle {
    ignore_changes = [subdomain]
  }
}

# -----------------------------------------------------------------------------
# STEP 2: Base Service Entitlements (every customer gets these)
# -----------------------------------------------------------------------------

resource "btp_subaccount_entitlement" "destination" {
  for_each      = var.customers
  subaccount_id = btp_subaccount.customer[each.key].id
  service_name  = "destination"
  plan_name     = "lite"
}

resource "btp_subaccount_entitlement" "xsuaa" {
  for_each      = var.customers
  subaccount_id = btp_subaccount.customer[each.key].id
  service_name  = "xsuaa"
  plan_name     = "application"
}

resource "btp_subaccount_entitlement" "html5_repo" {
  for_each      = var.customers
  subaccount_id = btp_subaccount.customer[each.key].id
  service_name  = "html5-apps-repo"
  plan_name     = "app-host"
}

# -----------------------------------------------------------------------------
# STEP 3: Destination Service Instance (per customer)
# -----------------------------------------------------------------------------

data "btp_subaccount_service_plan" "destination" {
  for_each      = var.customers
  subaccount_id = btp_subaccount.customer[each.key].id
  name          = "lite"
  offering_name = "destination"
  depends_on    = [btp_subaccount_entitlement.destination]
}

resource "btp_subaccount_service_instance" "destination" {
  for_each       = var.customers
  subaccount_id  = btp_subaccount.customer[each.key].id
  name           = "destination-instance"
  serviceplan_id = data.btp_subaccount_service_plan.destination[each.key].id
  depends_on     = [btp_subaccount_entitlement.destination]
}

# -----------------------------------------------------------------------------
# STEP 4: Additional Services (per customer, driven by config)
# -----------------------------------------------------------------------------

locals {
  # Flatten customer × additional_services into a map for for_each
  customer_services = merge([
    for customer_id, customer in var.customers : {
      for svc in customer.additional_services :
      "${customer_id}-${svc}" => {
        customer_id  = customer_id
        service_key  = svc
        service_name = local.service_catalog[svc].service_name
        plan_name    = local.service_catalog[svc].plan_name
        amount       = local.service_catalog[svc].amount
      }
      if contains(keys(local.service_catalog), svc)
    }
  ]...)
}

resource "btp_subaccount_entitlement" "additional" {
  for_each      = local.customer_services
  subaccount_id = btp_subaccount.customer[each.value.customer_id].id
  service_name  = each.value.service_name
  plan_name     = each.value.plan_name
  amount        = each.value.amount
}

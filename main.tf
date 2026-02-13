# =============================================================================
# SAP BTP + TERRAFORM DEMO
# =============================================================================
#
# SCENARIO: Automated Customer Onboarding Platform
#
# Nexaminds needs to onboard enterprise customers to SAP BTP.
# Each customer needs their own isolated environment with:
# - Integration services for connecting to external systems
# - Authorization and security configuration
# - Application hosting capabilities
# - Proper user roles and permissions
#
# Manual setup: 2-4 hours per customer
# With Terraform: ~2 minutes per customer
#
# =============================================================================

# -----------------------------------------------------------------------------
# DATA SOURCES - Read existing account info
# -----------------------------------------------------------------------------

data "btp_globalaccount" "this" {}

# -----------------------------------------------------------------------------
# STEP 1: Create Customer Subaccount
# -----------------------------------------------------------------------------

resource "btp_subaccount" "customer" {
  name        = "${var.customer_name} Portal"
  subdomain   = "${var.customer_id}-portal-${formatdate("YYYYMMDDhhmmss", timestamp())}"
  region      = var.region
  description = "Customer environment for ${var.customer_name} - created by Terraform"

  labels = {
    "managed-by"  = ["terraform"]
    "environment" = ["demo"]
    "customer"    = [var.customer_id]
  }

  lifecycle {
    ignore_changes = [subdomain]
  }
}

# -----------------------------------------------------------------------------
# STEP 2: Entitle Services
# -----------------------------------------------------------------------------

resource "btp_subaccount_entitlement" "destination" {
  subaccount_id = btp_subaccount.customer.id
  service_name  = "destination"
  plan_name     = "lite"
}

resource "btp_subaccount_entitlement" "xsuaa" {
  subaccount_id = btp_subaccount.customer.id
  service_name  = "xsuaa"
  plan_name     = "application"
}

resource "btp_subaccount_entitlement" "html5_repo" {
  subaccount_id = btp_subaccount.customer.id
  service_name  = "html5-apps-repo"
  plan_name     = "app-host"
}

# -----------------------------------------------------------------------------
# STEP 3: Create Service Instances
# -----------------------------------------------------------------------------

data "btp_subaccount_service_plan" "destination" {
  subaccount_id = btp_subaccount.customer.id
  name          = "lite"
  offering_name = "destination"
  depends_on    = [btp_subaccount_entitlement.destination]
}

resource "btp_subaccount_service_instance" "destination" {
  subaccount_id  = btp_subaccount.customer.id
  name           = "destination-instance"
  serviceplan_id = data.btp_subaccount_service_plan.destination.id
  depends_on     = [btp_subaccount_entitlement.destination]
}

# -----------------------------------------------------------------------------
# OPTIONAL SERVICES (Enable per customer via additional_services variable)
# -----------------------------------------------------------------------------

resource "btp_subaccount_entitlement" "additional" {
  for_each      = local.enabled_services
  subaccount_id = btp_subaccount.customer.id
  service_name  = each.value.service_name
  plan_name     = each.value.plan_name
  amount        = each.value.amount
}

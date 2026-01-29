# =============================================================================
# SAP BTP + TERRAFORM DEMO
# =============================================================================
#
# SCENARIO: Automated Customer Onboarding Platform
#
# NexaMinds needs to onboard enterprise customers to SAP BTP.
# Each customer needs their own isolated environment with:
# - Development tools (Business Application Studio)
# - User portal (SAP Build Work Zone)
# - Integration services (Destination)
# - Security (XSUAA)
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
# A subaccount is an isolated environment (like an AWS account)

resource "btp_subaccount" "customer" {
  name        = "NexaMinds Customer Portal"
  subdomain   = "nexaminds-portal-demo"
  region      = var.region
  description = "Customer environment created by Terraform"

  labels = {
    "managed-by"  = ["terraform"]
    "environment" = ["demo"]
    "customer"    = ["nexaminds"]
  }
}

# -----------------------------------------------------------------------------
# STEP 2: Entitle Services
# -----------------------------------------------------------------------------
# Entitlements = permissions to use services (like AWS service quotas)

resource "btp_subaccount_entitlement" "bas" {
  subaccount_id = btp_subaccount.customer.id
  service_name  = "sapappstudio"
  plan_name     = "standard-edition"
}

resource "btp_subaccount_entitlement" "destination" {
  subaccount_id = btp_subaccount.customer.id
  service_name  = "destination"
  plan_name     = "lite"
}

resource "btp_subaccount_entitlement" "workzone" {
  subaccount_id = btp_subaccount.customer.id
  service_name  = "SAPLaunchpad"
  plan_name     = "standard"
}

# -----------------------------------------------------------------------------
# STEP 3: Subscribe to Applications
# -----------------------------------------------------------------------------
# Subscriptions = activate SaaS apps

resource "btp_subaccount_subscription" "bas" {
  subaccount_id = btp_subaccount.customer.id
  app_name      = "sapappstudio"
  plan_name     = "standard-edition"
  depends_on    = [btp_subaccount_entitlement.bas]
}

resource "btp_subaccount_subscription" "workzone" {
  subaccount_id = btp_subaccount.customer.id
  app_name      = "SAPLaunchpad"
  plan_name     = "standard"
  depends_on    = [btp_subaccount_entitlement.workzone]
}

# -----------------------------------------------------------------------------
# STEP 4: Assign User Roles
# -----------------------------------------------------------------------------
# Give users access to the applications

resource "btp_subaccount_role_collection_assignment" "bas_developer" {
  subaccount_id        = btp_subaccount.customer.id
  role_collection_name = "Business_Application_Studio_Developer"
  user_name            = var.btp_username
  depends_on           = [btp_subaccount_subscription.bas]
}

resource "btp_subaccount_role_collection_assignment" "workzone_admin" {
  subaccount_id        = btp_subaccount.customer.id
  role_collection_name = "Launchpad_Admin"
  user_name            = var.btp_username
  depends_on           = [btp_subaccount_subscription.workzone]
}

# -----------------------------------------------------------------------------
# OUTPUTS - What was created
# -----------------------------------------------------------------------------

output "customer_subaccount" {
  value = {
    name      = btp_subaccount.customer.name
    subdomain = btp_subaccount.customer.subdomain
    region    = btp_subaccount.customer.region
  }
}

output "application_urls" {
  value = {
    business_application_studio = btp_subaccount_subscription.bas.subscription_url
    work_zone_launchpad         = btp_subaccount_subscription.workzone.subscription_url
  }
}

output "demo_complete" {
  value = <<-EOT

  ================================================================
       CUSTOMER ENVIRONMENT DEPLOYED SUCCESSFULLY!
  ================================================================

  What Terraform just created:

    1. Subaccount: NexaMinds Customer Portal
    2. Entitled 3 services
    3. Subscribed to 2 applications
    4. Assigned roles to user

  Time with Terraform:  ~2 minutes
  Time manually:        ~2 hours

  ================================================================
  EOT
}

# =============================================================================
# SAP BTP + TERRAFORM DEMO
# =============================================================================
#
# SCENARIO: Automated Customer Onboarding Platform
#
# Nexaminds needs to onboard enterprise customers to SAP BTP.
# Each customer needs their own isolated environment with:
# - Development tools (Business Application Studio)
# - Integration services (Destination)
# - Authorization (XSUAA)
#
# Manual setup: 2-4 hours per customer
# With Terraform: ~2 minutes per customer
#
# NOTE: This demo is configured for TRIAL accounts.
#       For enterprise accounts, uncomment the additional services below.
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
  name        = "Nexaminds Customer Portal"
  subdomain   = "Nexaminds-portal-${formatdate("YYYYMMDDhhmmss", timestamp())}"
  region      = var.region
  description = "Customer environment created by Terraform"

  labels = {
    "managed-by"  = ["terraform"]
    "environment" = ["demo"]
    "customer"    = ["Nexaminds"]
  }

  # Prevent subdomain from changing on every apply
  lifecycle {
    ignore_changes = [subdomain]
  }
}

# -----------------------------------------------------------------------------
# STEP 2: Entitle Services
# -----------------------------------------------------------------------------
# Entitlements = permissions to use services (like AWS service quotas)

# Destination Service - for connecting to external systems
resource "btp_subaccount_entitlement" "destination" {
  subaccount_id = btp_subaccount.customer.id
  service_name  = "destination"
  plan_name     = "lite"
}

# XSUAA - Authorization and Trust Management
resource "btp_subaccount_entitlement" "xsuaa" {
  subaccount_id = btp_subaccount.customer.id
  service_name  = "xsuaa"
  plan_name     = "application"
}

# HTML5 Application Repository - for hosting UI apps
resource "btp_subaccount_entitlement" "html5_repo" {
  subaccount_id = btp_subaccount.customer.id
  service_name  = "html5-apps-repo"
  plan_name     = "app-host"
}

# -----------------------------------------------------------------------------
# STEP 3: Create Service Instances
# -----------------------------------------------------------------------------
# Service instances = actual provisioned services you can use

resource "btp_subaccount_service_instance" "destination" {
  subaccount_id  = btp_subaccount.customer.id
  name           = "destination-instance"
  serviceplan_id = data.btp_subaccount_service_plan.destination.id
  depends_on     = [btp_subaccount_entitlement.destination]
}

data "btp_subaccount_service_plan" "destination" {
  subaccount_id = btp_subaccount.customer.id
  name          = "lite"
  offering_name = "destination"
  depends_on    = [btp_subaccount_entitlement.destination]
}

# -----------------------------------------------------------------------------
# STEP 4: Assign User Roles
# -----------------------------------------------------------------------------
# Give users access to manage destinations

resource "btp_subaccount_role_collection_assignment" "subaccount_admin" {
  subaccount_id        = btp_subaccount.customer.id
  role_collection_name = "Subaccount Administrator"
  user_name            = var.btp_username
}

# =============================================================================
# ENTERPRISE ACCOUNT ADDITIONS (Uncomment if you have enterprise entitlements)
# =============================================================================

# # Business Application Studio - Cloud IDE
# resource "btp_subaccount_entitlement" "bas" {
#   subaccount_id = btp_subaccount.customer.id
#   service_name  = "sapappstudio"
#   plan_name     = "standard-edition"  # Use "free" for trial if available
# }

# resource "btp_subaccount_subscription" "bas" {
#   subaccount_id = btp_subaccount.customer.id
#   app_name      = "sapappstudio"
#   plan_name     = "standard-edition"
#   depends_on    = [btp_subaccount_entitlement.bas]
# }

# resource "btp_subaccount_role_collection_assignment" "bas_developer" {
#   subaccount_id        = btp_subaccount.customer.id
#   role_collection_name = "Business_Application_Studio_Developer"
#   user_name            = var.btp_username
#   depends_on           = [btp_subaccount_subscription.bas]
# }

# # SAP Build Work Zone (requires OIDC trust to SAP IAS)
# resource "btp_subaccount_entitlement" "workzone" {
#   subaccount_id = btp_subaccount.customer.id
#   service_name  = "SAPLaunchpad"
#   plan_name     = "standard"
# }

# resource "btp_subaccount_subscription" "workzone" {
#   subaccount_id = btp_subaccount.customer.id
#   app_name      = "SAPLaunchpad"
#   plan_name     = "standard"
#   depends_on    = [btp_subaccount_entitlement.workzone]
# }

# -----------------------------------------------------------------------------
# OUTPUTS - What was created
# -----------------------------------------------------------------------------

output "subaccount_info" {
  description = "Created subaccount details"
  value = {
    id        = btp_subaccount.customer.id
    name      = btp_subaccount.customer.name
    subdomain = btp_subaccount.customer.subdomain
    region    = btp_subaccount.customer.region
  }
}

output "services_created" {
  description = "Services provisioned in the subaccount"
  value = {
    destination_instance = btp_subaccount_service_instance.destination.name
  }
}

output "cockpit_url" {
  description = "Direct link to the subaccount in BTP Cockpit"
  value       = "https://cockpit.btp.cloud.sap/cockpit/#/globalaccount/${var.globalaccount_subdomain}/subaccount/${btp_subaccount.customer.id}"
}

output "demo_complete" {
  value = <<-EOT

  ================================================================
       CUSTOMER ENVIRONMENT DEPLOYED SUCCESSFULLY!
  ================================================================

  What Terraform created:

    1. Subaccount: ${btp_subaccount.customer.name}
    2. Region: ${btp_subaccount.customer.region}
    3. Services: Destination, XSUAA, HTML5 Repo (entitled)
    4. Destination service instance created
    5. Admin role assigned to ${var.btp_username}

  Next steps:
    - Open BTP Cockpit to see your new subaccount
    - Create destinations to connect to external systems
    - Deploy applications to the subaccount

  Time with Terraform:  ~2 minutes
  Time manually:        ~2 hours

  ================================================================
  EOT
}

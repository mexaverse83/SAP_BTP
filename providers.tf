# SAP BTP Provider Configuration
# Credentials should be set as workspace variables in HCP Terraform:
#   - BTP_USERNAME (environment variable)
#   - BTP_PASSWORD (environment variable, sensitive)
# Or locally via: export BTP_USERNAME="..." && export BTP_PASSWORD="..."

provider "btp" {
  globalaccount = var.globalaccount_subdomain
  cli_server_url = "https://cli.btp.cloud.sap"  # Works for both trial and enterprise
}

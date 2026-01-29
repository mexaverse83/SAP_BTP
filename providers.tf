# SAP BTP Terraform Provider Configuration

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    btp = {
      source  = "SAP/btp"
      version = "~> 1.0"
    }
  }
}

# SAP BTP Provider
# Authentication options:
# 1. Username/Password (basic)
# 2. Custom IDP
# 3. X.509 certificates

provider "btp" {
  globalaccount = var.globalaccount_subdomain

  # Credentials - can also use BTP_USERNAME and BTP_PASSWORD env vars
  username = var.btp_username
  password = var.btp_password

  # Trial accounts use a different CLI server
  cli_server_url = "https://cli.btp.cloud.sap"
}

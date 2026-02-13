# Version constraints and backend configuration

terraform {
  required_version = ">= 1.5.0"

  cloud {
    organization = "Nexaminds"

    workspaces {
      name = "SAP_BTP_DEMO"
    }
  }

  required_providers {
    btp = {
      source  = "SAP/btp"
      version = "~> 1.0"
    }
  }
}

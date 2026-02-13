# SAP BTP Connection Variables

variable "globalaccount_subdomain" {
  description = "SAP BTP global account subdomain"
  type        = string
}

variable "region" {
  description = "SAP BTP region"
  type        = string
  default     = "us10"

  validation {
    condition     = contains(["us10", "eu10", "ap21", "us20", "eu20", "jp10"], var.region)
    error_message = "Region must be a valid SAP BTP region."
  }
}

# Customer-specific Variables

variable "customer_name" {
  description = "Customer name (e.g., 'ACME Corp')"
  type        = string
  default     = "Nexaminds"
}

variable "customer_id" {
  description = "Short customer identifier for subdomain (lowercase, no spaces)"
  type        = string
  default     = "nexaminds"

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.customer_id))
    error_message = "Customer ID must be lowercase alphanumeric with hyphens only."
  }
}

# Optional Services (enable per customer)

variable "additional_services" {
  description = "List of additional services to enable for this customer"
  type        = list(string)
  default     = []

  # Available services:
  # - "cf_runtime"    : Cloud Foundry runtime for deploying apps
  # - "hana_cloud"    : SAP HANA Cloud database (enterprise only)
  # - "connectivity"  : On-premise system connectivity
  # - "bas"           : Business Application Studio (enterprise only)
  # - "workzone"      : SAP Build Work Zone (enterprise only)
  # - "aicore"        : SAP AI Core (enterprise only)
}

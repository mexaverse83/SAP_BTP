# SAP BTP Connection Variables

variable "globalaccount_subdomain" {
  description = "SAP BTP global account subdomain"
  type        = string
}

variable "btp_username" {
  description = "SAP BTP username (email)"
  type        = string
}

variable "btp_password" {
  description = "SAP BTP password"
  type        = string
  sensitive   = true
}

variable "region" {
  description = "SAP BTP region"
  type        = string
  default     = "us10"
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
}

# Optional Services (enable per customer)
# Add service keys to this list to enable them for a customer

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

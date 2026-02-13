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

# Customer Configurations — define all customers in one map

variable "customers" {
  description = "Map of customers to onboard. Each key is the customer ID."
  type = map(object({
    name                = string
    additional_services = optional(list(string), [])
  }))
  default = {}

  # Example:
  # customers = {
  #   nexaminds = {
  #     name                = "Nexaminds"
  #     additional_services = []
  #   }
  #   cintas = {
  #     name                = "Cintas Corporation"
  #     additional_services = ["integration_suite", "analytics_cloud", "connectivity"]
  #   }
  # }
}

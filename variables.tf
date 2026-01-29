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

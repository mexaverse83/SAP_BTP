# =============================================================================
# DEMO — Dual Customer Onboarding
# =============================================================================
# Two customers, one apply. Shows scalability of the same Terraform code.
# =============================================================================

customers = {
  nexaminds = {
    name                = "Nexaminds"
    additional_services = []
  }

  cintas = {
    name                = "Cintas Corporation"
    additional_services = [
      "integration_suite",    # Connect S/4HANA ↔ Salesforce ↔ Oracle
      "analytics_cloud",      # Route efficiency, compliance dashboards
      "event_mesh",           # Real-time inventory & equipment alerts
      "workzone",             # Unified portal for 47K employees
      "mobile_services",      # Field tech mobile access
      "connectivity",         # Bridge to on-prem SAP & Oracle
      "document_management",  # OSHA compliance, fire safety inspections
    ]
  }
}

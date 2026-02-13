# =============================================================================
# CINTAS CORPORATION — Customer Configuration
# =============================================================================
# $10.3B revenue | 47K employees | 1M+ customers | Facilities Services
#
# SAP Stack: S/4HANA, Hybris, SuccessFactors (confirmed)
# Key Pain: Multi-system integration (Salesforce + Dynamics + Oracle + SAP)
# Opportunity: No IaC detected — manual BTP provisioning today
# =============================================================================

customer_name = "Cintas Corporation"
customer_id   = "cintas"

# Services tailored to Cintas's needs:
# - integration_suite: Connect S/4HANA ↔ Salesforce ↔ Oracle ↔ Dynamics 365
# - analytics_cloud:   Route efficiency, compliance reporting, sales dashboards
# - event_mesh:        Real-time inventory alerts, equipment inspection tracking
# - workzone:          Unified portal for 47K employees across thousands of locations
# - mobile_services:   Field techs need mobile access to service orders + routes
# - connectivity:      Bridge to on-premise S/4HANA and Oracle systems
# - document_management: OSHA compliance docs, fire safety inspections, contracts

additional_services = [
  "integration_suite",
  "analytics_cloud",
  "event_mesh",
  "workzone",
  "mobile_services",
  "connectivity",
  "document_management",
]

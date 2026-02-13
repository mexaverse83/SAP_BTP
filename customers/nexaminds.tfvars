# =============================================================================
# NEXAMINDS — Simple Customer Configuration
# =============================================================================
# Demo: Shows basic onboarding with core services only.
# Contrast with Cintas to demonstrate scalability of the same Terraform code.
# =============================================================================

customer_name = "Nexaminds"
customer_id   = "nexaminds"

# Core services only — Destination, XSUAA, HTML5 Repo are always included.
# No additional services needed for a simple deployment.
additional_services = []

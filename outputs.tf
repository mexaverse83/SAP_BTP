# Output values

output "subaccount_info" {
  description = "Created subaccount details"
  value = {
    id        = btp_subaccount.customer.id
    name      = btp_subaccount.customer.name
    subdomain = btp_subaccount.customer.subdomain
    region    = btp_subaccount.customer.region
  }
}

output "services_created" {
  description = "Services provisioned in the subaccount"
  value = {
    destination_instance = btp_subaccount_service_instance.destination.name
  }
}

output "cockpit_url" {
  description = "Direct link to the subaccount in BTP Cockpit"
  value       = "https://cockpit.btp.cloud.sap/cockpit/#/globalaccount/${var.globalaccount_subdomain}/subaccount/${btp_subaccount.customer.id}"
}

output "demo_complete" {
  description = "Summary of deployed resources"
  value       = <<-EOT

  ================================================================
       ${upper(var.customer_name)} ENVIRONMENT DEPLOYED!
  ================================================================

  What Terraform created:

    1. Customer: ${var.customer_name}
    2. Subaccount: ${btp_subaccount.customer.name}
    3. Region: ${btp_subaccount.customer.region}
    4. Services: Destination, XSUAA, HTML5 Repo (entitled)
    5. Destination service instance created

  State: Stored in HCP Terraform (Nexaminds org)
  Time:  ~2 minutes (vs ~2 hours manually)

  ================================================================
  EOT
}

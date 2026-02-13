# Output values

output "subaccounts" {
  description = "Created subaccount details per customer"
  value = {
    for customer_id, customer in var.customers : customer_id => {
      id        = btp_subaccount.customer[customer_id].id
      name      = btp_subaccount.customer[customer_id].name
      subdomain = btp_subaccount.customer[customer_id].subdomain
      region    = btp_subaccount.customer[customer_id].region
      services  = concat(
        ["destination", "xsuaa", "html5-apps-repo"],
        customer.additional_services
      )
    }
  }
}

output "cockpit_urls" {
  description = "Direct links to each customer subaccount in BTP Cockpit"
  value = {
    for customer_id, customer in var.customers : customer_id =>
    "https://cockpit.btp.cloud.sap/cockpit/#/globalaccount/${var.globalaccount_subdomain}/subaccount/${btp_subaccount.customer[customer_id].id}"
  }
}

output "demo_summary" {
  description = "Summary of all deployed customer environments"
  value       = <<-EOT

  ================================================================
       CUSTOMER ONBOARDING COMPLETE!
  ================================================================
  %{for customer_id, customer in var.customers~}

    ✅ ${customer.name}
       Services: ${length(customer.additional_services) + 3} (3 base + ${length(customer.additional_services)} additional)
  %{endfor~}

  Total customers: ${length(var.customers)}
  State: HCP Terraform (Nexaminds org)
  Time:  ~2 minutes (vs ~${length(var.customers) * 3} hours manually)

  ================================================================
  EOT
}

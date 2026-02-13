# Local values

locals {
  # Service catalog - maps service keys to SAP BTP service details
  # Enable per customer via the additional_services variable
  service_catalog = {
    # Runtime & Development
    cf_runtime = {
      service_name = "APPLICATION_RUNTIME"
      plan_name    = "MEMORY"
      amount       = 1
      description  = "Cloud Foundry runtime for deploying applications"
    }
    bas = {
      service_name = "sapappstudio"
      plan_name    = "standard-edition"
      amount       = null
      description  = "Business Application Studio — cloud IDE"
    }

    # Data & Analytics
    hana_cloud = {
      service_name = "hana-cloud"
      plan_name    = "hana"
      amount       = null
      description  = "SAP HANA Cloud database"
    }
    analytics_cloud = {
      service_name = "sapanalyticscloud"
      plan_name    = "standard"
      amount       = null
      description  = "SAP Analytics Cloud — BI, planning, predictive"
    }
    datasphere = {
      service_name = "datasphere"
      plan_name    = "standard"
      amount       = null
      description  = "SAP Datasphere — data orchestration and governance"
    }

    # Integration & Connectivity
    integration_suite = {
      service_name = "integration-suite"
      plan_name    = "enterprise_agreement"
      amount       = null
      description  = "SAP Integration Suite — iPaaS for multi-system connectivity"
    }
    connectivity = {
      service_name = "connectivity"
      plan_name    = "lite"
      amount       = null
      description  = "On-premise system connectivity"
    }
    event_mesh = {
      service_name = "enterprise-messaging"
      plan_name    = "default"
      amount       = null
      description  = "SAP Event Mesh — real-time event-driven architecture"
    }

    # User Experience
    workzone = {
      service_name = "SAPLaunchpad"
      plan_name    = "standard"
      amount       = null
      description  = "SAP Build Work Zone — unified employee portal"
    }
    mobile_services = {
      service_name = "mobile-services"
      plan_name    = "standard"
      amount       = null
      description  = "SAP Mobile Services — field workforce apps"
    }
    document_management = {
      service_name = "document-management"
      plan_name    = "standard"
      amount       = null
      description  = "SAP Document Management — compliance and archival"
    }

    # AI & Automation
    aicore = {
      service_name = "aicore"
      plan_name    = "extended"
      amount       = null
      description  = "SAP AI Core — ML model training and inference"
    }
    alert_notification = {
      service_name = "alert-notification"
      plan_name    = "standard"
      amount       = null
      description  = "Alert Notification — SLA and threshold alerts"
    }
  }

  # Note: per-customer service filtering is handled in main.tf locals block
}

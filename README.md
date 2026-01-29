# SAP BTP + Terraform Demo

Automate SAP BTP environment provisioning with Terraform. Clone, configure, deploy.

---

## Table of Contents

- [Quick Start](#quick-start)
- [Configuration Reference](#configuration-reference)
- [What Gets Created](#what-gets-created)
- [Project Files](#project-files)
- [Troubleshooting](#troubleshooting)
- [Customization](#customization)
- [What is Terraform?](#what-is-terraform)
- [What is SAP BTP?](#what-is-sap-btp)
- [How the Code Works](#how-the-code-works)
- [The Business Value](#the-business-value)
- [Demo Script for Presentations](#demo-script-for-presentations)
- [Further Learning](#further-learning)

---

## Quick Start

### Step 1: Clone the Repository

```bash
git clone https://github.com/mexaverse83/SAP_BTP.git
cd SAP_BTP
```

### Step 2: Install Terraform

Download from [terraform.io/downloads](https://www.terraform.io/downloads) or use a package manager:

```bash
# macOS
brew install terraform

# Windows (Chocolatey)
choco install terraform

# Ubuntu/Debian
sudo apt-get install terraform

# Verify installation (requires v1.5.0+)
terraform --version
```

### Step 3: Configure Your Credentials

```bash
# Copy the template
cp terraform.tfvars.example terraform.tfvars

# Edit with your values
code terraform.tfvars      # VS Code
notepad terraform.tfvars   # Windows
nano terraform.tfvars      # Linux/Mac
```

### Step 4: Deploy

```bash
# Initialize (downloads SAP BTP provider)
terraform init

# Preview changes
terraform plan

# Deploy (type 'yes' when prompted)
terraform apply
```

### Step 5: Clean Up

```bash
# Remove all created resources
terraform destroy
```

---

## Configuration Reference

### Required Variables

Edit `terraform.tfvars` with your values:

```hcl
globalaccount_subdomain = "your-subdomain"      # Required
btp_username            = "your@email.com"      # Required
btp_password            = "your-password"       # Required
region                  = "us10"                # Optional (default: us10)
```

### Variable Details

| Variable | Required | Description | Example |
|----------|----------|-------------|---------|
| `globalaccount_subdomain` | Yes | Your BTP global account subdomain | `"12345678trial-ga"` |
| `btp_username` | Yes | SAP BTP login email | `"user@company.com"` |
| `btp_password` | Yes | SAP BTP login password | `"MyPassword123"` |
| `region` | No | BTP datacenter region | `"eu10"` |

### Finding Your Global Account Subdomain

1. Go to [SAP BTP Cockpit](https://cockpit.btp.cloud.sap)
2. Log in with your SAP credentials
3. Find the subdomain in:
   - **The URL:** `https://cockpit.btp.cloud.sap/cockpit/#/globalaccount/YOUR-SUBDOMAIN/...`
   - **The overview page:** Look for "Subdomain" field

**Examples:**
- Trial account: `12345678trial-ga`
- Enterprise account: `mycompany-prod`

### Available Regions

| Code | Location | Trial |
|------|----------|-------|
| `us10` | US East (Virginia) | Yes |
| `eu10` | Europe (Frankfurt) | Yes |
| `ap21` | Singapore | Yes |
| `us20` | US West | No |
| `eu20` | Netherlands | No |
| `jp10` | Japan | No |

---

## What Gets Created

When you run `terraform apply`, this demo creates:

```
Nexaminds Customer Portal (Subaccount)
│
├── Service Entitlements
│   ├── Destination Service (lite)
│   ├── XSUAA (application)
│   └── HTML5 App Repository (app-host)
│
├── Service Instances
│   └── Destination Instance
│
└── Role Assignments
    └── Subaccount Administrator → Your user
```

**Time comparison:**
- Manual setup: ~2-4 hours
- With Terraform: ~2 minutes

---

## Project Files

```
sap-btp-playground/
├── main.tf                  # Infrastructure definitions
├── variables.tf             # Variable declarations
├── providers.tf             # Terraform + SAP BTP provider config
├── terraform.tfvars.example # Template for your credentials
├── terraform.tfvars         # YOUR credentials (git-ignored)
├── .gitignore               # Protects sensitive files
└── README.md                # This file
```

| File | Purpose | Edit This? |
|------|---------|------------|
| `terraform.tfvars` | Your credentials | **Yes** |
| `main.tf` | Resources to create | Optional |
| `variables.tf` | Variable definitions | No |
| `providers.tf` | Provider settings | No |

---

## Troubleshooting

### Authentication Failed

```
Error: could not authenticate with SAP BTP
```

**Fix:**
- Verify username/password in `terraform.tfvars`
- Test logging into [BTP Cockpit](https://cockpit.btp.cloud.sap)
- Escape special characters in password if needed

### Entitlement Not Available

```
Error: entitlement for service 'sapappstudio' not found
```

**Fix:**
- Check Global Account → Entitlements in BTP Cockpit
- Trial accounts have limited services
- Enterprise accounts need entitlements assigned

### Subdomain Already Exists

```
Error: subdomain 'nexaminds-portal-demo' is already in use
```

**Fix:** The demo uses a timestamp-based subdomain, but if you still get conflicts, edit `main.tf`:
```hcl
subdomain = "my-unique-name-123"
```

### Region Not Supported

```
Error: region 'us10' is not available
```

**Fix:** Update `terraform.tfvars`:
```hcl
region = "eu10"
```

---

## Customization

### Change Subaccount Name

Edit `main.tf`:
```hcl
resource "btp_subaccount" "customer" {
  name        = "My Custom Name"
  subdomain   = "my-custom-subdomain"
  ...
}
```

### Add Another User

Add to `main.tf`:
```hcl
resource "btp_subaccount_role_collection_assignment" "new_admin" {
  subaccount_id        = btp_subaccount.customer.id
  role_collection_name = "Subaccount Administrator"
  user_name            = "newuser@company.com"
}
```

### Add More Services

Add entitlement in `main.tf`:
```hcl
resource "btp_subaccount_entitlement" "hana" {
  subaccount_id = btp_subaccount.customer.id
  service_name  = "hana-cloud"
  plan_name     = "hana"
}
```

---

## What is Terraform?

### Introduction

**Terraform** is an open-source Infrastructure-as-Code (IaC) tool developed by HashiCorp. It has become the industry standard for defining, provisioning, and managing cloud infrastructure across any platform.

### The Core Idea

Instead of clicking through web consoles to create resources, you write code that describes what you want. Terraform then:

1. **Reads** your configuration files
2. **Plans** what changes need to be made
3. **Applies** those changes via cloud provider APIs
4. **Tracks** what it created in a state file

### Key Concepts

| Concept | Description |
|---------|-------------|
| **Declarative Syntax** | You describe the desired end state, not the steps to get there. Terraform figures out the "how". |
| **HCL (HashiCorp Configuration Language)** | A human-readable language designed for infrastructure. Easy to learn, easy to maintain. |
| **Providers** | Plugins that connect Terraform to cloud platforms. There are 3,000+ providers for AWS, Azure, GCP, SAP BTP, Kubernetes, and more. |
| **Resources** | The building blocks of infrastructure (VMs, databases, subaccounts, etc.). |
| **State** | Terraform tracks what it has created in a state file, enabling updates, deletions, and drift detection. |
| **Plan** | A preview of what Terraform will do before it does it. No surprises. |

### How Terraform Works

```
┌─────────────────────────────────────────────────────────────────────────┐
│                          YOUR COMPUTER                                   │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│   ┌──────────────┐    ┌──────────────┐    ┌──────────────┐              │
│   │  main.tf     │    │ variables.tf │    │ providers.tf │              │
│   │  (Resources) │    │  (Inputs)    │    │  (Config)    │              │
│   └──────┬───────┘    └──────┬───────┘    └──────┬───────┘              │
│          └───────────────────┼───────────────────┘                       │
│                              ▼                                           │
│                    ┌──────────────────┐                                  │
│                    │  terraform init  │  ← Downloads providers           │
│                    └────────┬─────────┘                                  │
│                             ▼                                            │
│                    ┌──────────────────┐                                  │
│                    │  terraform plan  │  ← Shows what will change        │
│                    └────────┬─────────┘                                  │
│                             ▼                                            │
│                    ┌──────────────────┐                                  │
│                    │  terraform apply │  ← Executes the changes          │
│                    └────────┬─────────┘                                  │
└─────────────────────────────┼────────────────────────────────────────────┘
                              │ HTTPS API Calls
                              ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                        SAP BTP CLOUD                                     │
│   ┌─────────────────────────────────────────────────────────────────┐   │
│   │                    Global Account                                │   │
│   │   ┌─────────────────────────────────────────────────────────┐   │   │
│   │   │              Subaccount (Created by Terraform)           │   │   │
│   │   │   • Services  • Subscriptions  • Role Assignments        │   │   │
│   │   └─────────────────────────────────────────────────────────┘   │   │
│   └─────────────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────────────┘
```

### Why Organizations Choose Terraform

| Benefit | Description |
|---------|-------------|
| **Multi-Cloud** | Manage AWS, Azure, GCP, SAP with one tool |
| **Version Control** | Store infrastructure in Git, review in PRs |
| **Collaboration** | Teams work together with proper workflows |
| **Idempotency** | Same code = same result, every time |
| **Modularity** | Create reusable modules for common patterns |
| **Automation** | Integrate with CI/CD pipelines |

### Terraform vs. Manual Configuration

| Aspect | Manual (BTP Cockpit) | Terraform |
|--------|---------------------|-----------|
| **Time** | 2-4 hours | ~2 minutes |
| **Consistency** | Human error prone | 100% consistent |
| **Documentation** | Requires separate docs | Code IS documentation |
| **Repeatability** | Start from scratch | Run unlimited times |
| **Rollback** | Manual, error-prone | `terraform destroy` |
| **Audit Trail** | Screenshots? Notes? | Full Git history |

---

## What is SAP BTP?

### Introduction

**SAP Business Technology Platform (BTP)** is SAP's unified cloud platform that brings together application development, data management, analytics, AI, and integration capabilities. It's the foundation for extending and integrating SAP solutions in the cloud.

### Why SAP BTP Exists

Organizations using SAP systems (S/4HANA, SuccessFactors, Ariba, etc.) need a way to:

- **Extend** SAP applications with custom functionality
- **Integrate** SAP with non-SAP systems
- **Analyze** data across the enterprise
- **Automate** business processes
- **Build** new cloud-native applications

### BTP Architecture

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         GLOBAL ACCOUNT                                   │
│                    (Organization Level)                                  │
│  • Owned by your organization                                           │
│  • Contains all entitlements (service quotas)                           │
│  • Manages billing and contracts                                        │
├─────────────────────────────────────────────────────────────────────────┤
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐          │
│  │   SUBACCOUNT    │  │   SUBACCOUNT    │  │   SUBACCOUNT    │          │
│  │   (Customer A)  │  │   (Customer B)  │  │   (Dev/Test)    │          │
│  │  ┌───────────┐  │  │  ┌───────────┐  │  │  ┌───────────┐  │          │
│  │  │ Services  │  │  │  │ Services  │  │  │  │ Services  │  │          │
│  │  │ Apps      │  │  │  │ Apps      │  │  │  │ Apps      │  │          │
│  │  │ Users     │  │  │  │ Users     │  │  │  │ Users     │  │          │
│  │  └───────────┘  │  │  └───────────┘  │  │  └───────────┘  │          │
│  └─────────────────┘  └─────────────────┘  └─────────────────┘          │
└─────────────────────────────────────────────────────────────────────────┘
```

### Key BTP Capabilities

| Capability | Description | Example Services |
|------------|-------------|------------------|
| **Application Development** | Build apps with pro-code or low-code | Business Application Studio, SAP Build Apps |
| **Integration** | Connect SAP and non-SAP systems | Integration Suite, Destination Service |
| **Data & Analytics** | Store and analyze enterprise data | HANA Cloud, Analytics Cloud |
| **AI & Automation** | Embed intelligence in processes | AI Core, Build Process Automation |
| **User Experience** | Create unified portals | SAP Build Work Zone |

### BTP Terminology

| SAP BTP Term | Simple Explanation | AWS Equivalent |
|--------------|-------------------|----------------|
| **Global Account** | Organization's top-level account | AWS Organization |
| **Subaccount** | Isolated environment for a project | AWS Account |
| **Directory** | Folder to organize subaccounts | Organizational Unit |
| **Entitlement** | Permission to use a service | Service Quota |
| **Service Plan** | Tier/variant of a service | Pricing Tier |
| **Service Instance** | Provisioned instance of a service | RDS Instance |
| **Subscription** | Activated SaaS application | Marketplace Subscription |
| **Role Collection** | Bundle of user permissions | IAM Role |
| **Destination** | Connection config to external systems | Secrets Manager |

### Trial vs. Enterprise Accounts

| Feature | Trial | Enterprise |
|---------|-------|------------|
| **Cost** | Free | Paid |
| **Duration** | 90 days | Unlimited |
| **Services** | Limited | Full catalog |
| **Regions** | us10, eu10, ap21 | All |
| **Support** | Community | SAP Support |

---

## How the Code Works

### providers.tf — Connecting to SAP BTP

```hcl
terraform {
  required_providers {
    btp = {
      source  = "SAP/btp"
      version = "~> 1.0"
    }
  }
}

provider "btp" {
  globalaccount = var.globalaccount_subdomain
  username      = var.btp_username
  password      = var.btp_password
}
```

### variables.tf — Defining Inputs

```hcl
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
  sensitive   = true  # Won't show in logs
}

variable "region" {
  description = "SAP BTP region"
  type        = string
  default     = "us10"
}
```

### main.tf — The Infrastructure

**Step 1: Create Subaccount**
```hcl
resource "btp_subaccount" "customer" {
  name        = "Nexaminds Customer Portal"
  subdomain   = "nexaminds-portal-demo"
  region      = var.region
  description = "Customer environment created by Terraform"
}
```

**Step 2: Assign Entitlements**
```hcl
resource "btp_subaccount_entitlement" "destination" {
  subaccount_id = btp_subaccount.customer.id
  service_name  = "destination"
  plan_name     = "lite"
}
```

**Step 3: Create Service Instances**
```hcl
resource "btp_subaccount_service_instance" "destination" {
  subaccount_id  = btp_subaccount.customer.id
  name           = "destination-instance"
  serviceplan_id = data.btp_subaccount_service_plan.destination.id
  depends_on     = [btp_subaccount_entitlement.destination]
}
```

**Step 4: Assign Roles**
```hcl
resource "btp_subaccount_role_collection_assignment" "admin" {
  subaccount_id        = btp_subaccount.customer.id
  role_collection_name = "Subaccount Administrator"
  user_name            = var.btp_username
}
```

### The Dependency Chain

```
1. Create Subaccount
         │
         ▼
2. Assign Entitlements (needs subaccount)
         │
         ▼
3. Create Service Instances (needs entitlements)
         │
         ▼
4. Assign Roles (needs subaccount)
```

---

## The Business Value

### Time Savings Calculator

| Scenario | Manual Time | Terraform Time | Savings |
|----------|------------|----------------|---------|
| 1 customer | 3 hours | 2 minutes | 2.97 hours |
| 10 customers | 30 hours | 20 minutes | 29.7 hours |
| 50 customers | 150 hours | 1.7 hours | 148.3 hours |
| 100 customers | 300 hours | 3.3 hours | 296.7 hours |

### Beyond Time Savings

| Benefit | Description |
|---------|-------------|
| **Consistency** | Every customer gets exactly the same setup |
| **Compliance** | Infrastructure changes tracked in Git |
| **Disaster Recovery** | Redeploy in minutes, not hours |
| **Knowledge Transfer** | New team members read the code |
| **Testing** | Create identical dev/test/prod environments |
| **Self-Service** | Enable teams to provision with guardrails |

---

## Demo Script for Presentations

### The Problem (30 seconds)

> "Imagine onboarding 50 enterprise customers to SAP BTP. Each needs their own environment with development tools, a user portal, and integrations."
>
> "Manually, that's 2-4 hours per customer—clicking through 20+ screens in the BTP Cockpit. For 50 customers, that's over 100 hours of repetitive work."

### The Solution (30 seconds)

> "With Terraform, we define the infrastructure as code."
>
> *[Show main.tf]*
>
> "Look—it's readable. Anyone can see exactly what we're creating. It lives in Git, so we can track changes, do code reviews, and collaborate."

### The Demo (2 minutes)

> "Let's run it."

```bash
terraform apply
```

> "Terraform reads our configuration, calls the SAP BTP APIs, and creates everything: subaccount, services, role assignments."
>
> "In about 2 minutes, we have a fully provisioned customer environment."
>
> *[Show BTP Cockpit with created resources]*

### The Value (30 seconds)

> "This code can be reused for every customer. Run it 100 times, get 100 identical environments."
>
> "It's consistent, auditable, and repeatable. That's the power of Infrastructure as Code."

---

## Further Learning

### Terraform Resources

| Resource | URL |
|----------|-----|
| Terraform Documentation | [terraform.io/docs](https://www.terraform.io/docs) |
| Terraform Tutorials | [developer.hashicorp.com/terraform/tutorials](https://developer.hashicorp.com/terraform/tutorials) |
| Terraform Registry | [registry.terraform.io](https://registry.terraform.io/) |

### SAP BTP Resources

| Resource | URL |
|----------|-----|
| SAP BTP Documentation | [help.sap.com/docs/btp](https://help.sap.com/docs/btp) |
| SAP BTP Terraform Provider | [registry.terraform.io/providers/SAP/btp](https://registry.terraform.io/providers/SAP/btp/latest/docs) |
| SAP BTP Cockpit | [cockpit.btp.cloud.sap](https://cockpit.btp.cloud.sap) |
| SAP Learning Journey | [learning.sap.com](https://learning.sap.com/learning-journeys/discover-sap-business-technology-platform) |
| SAP Community | [community.sap.com](https://community.sap.com/) |

---

## Security

- `terraform.tfvars` is git-ignored — credentials never get committed
- For CI/CD, use environment variables:
  ```bash
  export TF_VAR_btp_username="user@company.com"
  export TF_VAR_btp_password="your-password"
  ```

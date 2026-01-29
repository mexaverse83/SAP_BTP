# SAP BTP + Terraform Demo

Automate SAP BTP environment provisioning with Terraform. Clone, configure, deploy.

> **New to Terraform or SAP BTP?** Read the [OVERVIEW.md](OVERVIEW.md) for a detailed explanation of the technologies, architecture diagrams, and what this demo does.

---

## Quick Start (5 Minutes)

### Step 1: Clone the Repository

```bash
git clone https://github.com/your-org/sap-btp-playground.git
cd sap-btp-playground
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

# Verify installation
terraform --version   # Requires v1.5.0+
```

### Step 3: Configure Your Credentials

Copy the example file and fill in your SAP BTP credentials:

```bash
# Copy the template
cp terraform.tfvars.example terraform.tfvars

# Edit with your favorite editor
code terraform.tfvars   # VS Code
# or
notepad terraform.tfvars   # Windows
# or
nano terraform.tfvars   # Linux/Mac
```

### Step 4: Deploy

```bash
# Initialize Terraform (downloads the SAP BTP provider)
terraform init

# Preview what will be created
terraform plan

# Deploy everything (type 'yes' when prompted)
terraform apply
```

### Step 5: Clean Up (When Done)

```bash
# Destroy all created resources
terraform destroy
```

---

## Required Variables

You must provide these values in `terraform.tfvars`:

| Variable | Required | Description | Example |
|----------|----------|-------------|---------|
| `globalaccount_subdomain` | **Yes** | Your SAP BTP global account subdomain | `"12345678trial-ga"` |
| `btp_username` | **Yes** | Your SAP BTP login email | `"user@company.com"` |
| `btp_password` | **Yes** | Your SAP BTP login password | `"MyPassword123"` |
| `region` | No | BTP region (default: `us10`) | `"eu10"` |

### How to Find Your Global Account Subdomain

1. Go to [SAP BTP Cockpit](https://cockpit.btp.cloud.sap)
2. Log in with your SAP credentials
3. Your subdomain is shown in:
   - The URL: `https://cockpit.btp.cloud.sap/cockpit/?idp=...#/globalaccount/YOUR-SUBDOMAIN-HERE/...`
   - Or the "Subdomain" field on your Global Account overview page

**Trial accounts:** Subdomain looks like `12345678trial-ga`
**Enterprise accounts:** Subdomain is your custom identifier

### Available Regions

| Region Code | Location | Trial Available |
|-------------|----------|-----------------|
| `us10` | US East (Virginia) | Yes |
| `eu10` | Europe (Frankfurt) | Yes |
| `ap21` | Singapore | Yes |
| `us20` | US West (Washington) | No |
| `eu20` | Europe (Netherlands) | No |
| `jp10` | Japan (Tokyo) | No |

---

## What Gets Created

When you run `terraform apply`, this demo creates:

```
Nxaminds Customer Portal (Subaccount)
│
├── Service Entitlements
│   ├── Business Application Studio (standard-edition)
│   ├── Destination Service (lite)
│   └── SAP Build Work Zone (standard)
│
├── Application Subscriptions
│   ├── Business Application Studio  →  Cloud IDE for developers
│   └── SAP Build Work Zone          →  User portal / launchpad
│
└── Role Assignments (for your user)
    ├── Business_Application_Studio_Developer
    └── Launchpad_Admin
```

**Time comparison:**
- Manual setup: ~2-4 hours
- With Terraform: ~2 minutes

---

## Project Files

```
sap-btp-playground/
├── main.tf                  # Infrastructure definitions (what gets created)
├── variables.tf             # Variable declarations
├── providers.tf             # Terraform + SAP BTP provider config
├── terraform.tfvars.example # Template for your credentials
├── terraform.tfvars         # YOUR credentials (git-ignored, you create this)
├── .gitignore               # Protects sensitive files from git
└── README.md                # This file
```

| File | Purpose | Edit This? |
|------|---------|------------|
| `terraform.tfvars` | Your credentials | **Yes** - Add your values |
| `main.tf` | Resources to create | Optional - Customize names/services |
| `variables.tf` | Variable definitions | No - Unless adding new variables |
| `providers.tf` | Provider settings | No - Unless changing auth method |

---

## Common Issues & Solutions

### Authentication Failed

```
Error: could not authenticate with SAP BTP
```

**Solutions:**
1. Verify your username/password in `terraform.tfvars`
2. Ensure you can log into [BTP Cockpit](https://cockpit.btp.cloud.sap) with these credentials
3. Check if your password contains special characters that need escaping

### Entitlement Not Available

```
Error: entitlement for service 'sapappstudio' not found
```

**Solutions:**
1. Log into BTP Cockpit → Go to your Global Account → Entitlements
2. Check if "SAP Business Application Studio" is available
3. For trial accounts, some services have limited availability

### Subdomain Already Exists

```
Error: subdomain 'Nxaminds-portal-demo' is already in use
```

**Solution:** Edit `main.tf` and change the subdomain to something unique:
```hcl
resource "btp_subaccount" "customer" {
  subdomain = "my-unique-subdomain-123"  # Change this
  ...
}
```

### Region Not Supported

```
Error: region 'us10' is not available for your account
```

**Solution:** Check your available regions in BTP Cockpit and update `terraform.tfvars`:
```hcl
region = "eu10"  # Try a different region
```

---

## Customization

### Change the Subaccount Name

Edit `main.tf`:

```hcl
resource "btp_subaccount" "customer" {
  name        = "My Custom Name"           # Display name
  subdomain   = "my-custom-subdomain"      # URL-friendly identifier
  description = "My custom description"
  ...
}
```

### Add More Services

Add new entitlements and subscriptions in `main.tf`:

```hcl
# Add HANA Cloud entitlement
resource "btp_subaccount_entitlement" "hana" {
  subaccount_id = btp_subaccount.customer.id
  service_name  = "hana-cloud"
  plan_name     = "hana"
}
```

### Add More Users

Add role assignments for additional users:

```hcl
resource "btp_subaccount_role_collection_assignment" "another_developer" {
  subaccount_id        = btp_subaccount.customer.id
  role_collection_name = "Business_Application_Studio_Developer"
  user_name            = "another.user@company.com"
  depends_on           = [btp_subaccount_subscription.bas]
}
```

---

## Learn More

For a comprehensive deep dive into:
- **What is Terraform?** — Core concepts, how it works, why organizations use it
- **What is SAP BTP?** — Architecture, capabilities, terminology explained
- **Detailed resource breakdown** — What each service does and why it's included
- **How the code works** — Line-by-line explanation of the Terraform files
- **Business value** — Time savings calculator and ROI analysis
- **Demo presentation script** — Ready-to-use talking points

**Read the full [OVERVIEW.md](OVERVIEW.md)**

---

## Quick Reference

| Term | Meaning |
|------|---------|
| **Global Account** | Your organization's top-level BTP account |
| **Subaccount** | Isolated environment for a project/customer |
| **Entitlement** | Permission to use a service |
| **Subscription** | Activated SaaS application |

---

## Links

| Resource | URL |
|----------|-----|
| SAP BTP Terraform Provider | [registry.terraform.io/providers/SAP/btp](https://registry.terraform.io/providers/SAP/btp/latest/docs) |
| Terraform Docs | [terraform.io/docs](https://www.terraform.io/docs) |
| SAP BTP Cockpit | [cockpit.btp.cloud.sap](https://cockpit.btp.cloud.sap) |
| SAP BTP Docs | [help.sap.com/docs/btp](https://help.sap.com/docs/btp) |

---

## Security

- `terraform.tfvars` is git-ignored — credentials never get committed
- For CI/CD, use environment variables:
  ```bash
  export TF_VAR_btp_username="user@company.com"
  export TF_VAR_btp_password="your-password"
  ```

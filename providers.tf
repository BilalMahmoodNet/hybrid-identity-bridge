terraform {
  required_version = ">= 1.4.0"
  required_providers {
    pingone = {
      source  = "pingidentity/pingone"
      version = "~> 1.0"
    }
    pingfederate = {
      source  = "pingidentity/pingfederate"
      version = "~> 1.7"
    }
  }
}

provider "pingone" {
  client_id      = var.pingone_client_id
  client_secret  = var.pingone_client_secret
  environment_id = var.pingone_environment_id
  region_code    = "EU" # Required for CI/CD
}

provider "pingfederate" {
  # This is the correct field name for PF provider
  https_host                = var.pf_base_url 
  username                  = "Admin"
  password                  = var.pingfederate_admin_password
  product_version           = "13.0" # Required to stop the CI error
  
  # The correct argument to skip SSL checks for local Docker
  insecure_trust_all_tls    = true 
}
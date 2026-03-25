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
  # Use Environment Variables for these to keep it "Secretless" in CI/CD
  # PINGONE_CLIENT_ID, PINGONE_CLIENT_SECRET, PINGONE_REGION, PINGONE_ENVIRONMENT_ID
  client_id      = var.pingone_client_id
  client_secret  = var.pingone_client_secret
  environment_id = var.pingone_environment_id
  region_code    = "EU" # OR "NA" - This was the missing region error
}

provider "pingfederate" {
  # Password and Host will be read from PINGFEDERATE_* env vars
  https_host                = var.pf_base_url 
  username                  = "Admin"
  password                  = var.pingfederate_admin_password
  product_version           = "13.0"        
  bypass_https_verification = true
  insecure_trust_all_tls  = true 
  admin_api_path          = "/pf-admin-api/v1"
}



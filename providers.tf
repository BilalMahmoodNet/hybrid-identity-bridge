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
}

provider "pingfederate" {
  # Password and Host will be read from PINGFEDERATE_* env vars

  insecure_trust_all_tls  = true 
  admin_api_path          = "/pf-admin-api/v1"
}
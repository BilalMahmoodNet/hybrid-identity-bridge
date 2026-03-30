terraform {
  required_version = ">= 1.4.0"
  required_providers {
    pingone = {
      source  = "pingidentity/pingone"
      version = "~> 1.0"
    }
    pingfederate = {
      source  = "pingidentity/pingfederate"
      version = "~> 1.7.0"
    }
    terracurl = {
      source  = "devops-rob/terracurl"
      version = "2.2.0"
    }
  }
}
provider "pingone" {
  client_id      = var.pingone_client_id
  client_secret  = var.pingone_client_secret
  environment_id = var.pingone_environment_id
  region_code    = var.pingone_region
}

provider "pingfederate" {
  username        = "Admin"  
  password        = "2FederateM0re"
  admin_api_path            = "/pf-admin-api/v1"
  https_host                = "https://127.0.0.1:9999"
  insecure_trust_all_tls    = true
  x_bypass_external_validation_header = true
  product_version           = "13.0"
}


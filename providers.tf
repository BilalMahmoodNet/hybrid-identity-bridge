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

terraform {
  backend "remote" {
    # 1. Using a free account at app.terraform.io
    hostname     = "app.terraform.io"
    organization = "bilalmahmoodnet"

    workspaces {
      name = "iam-vending-machine-dev"
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
  # This is the correct field name for PF provider
  client_id                 = var.pf_admin_client_id
  client_secret             = var.pf_admin_client_secret
  #scopes                    = ["openid", "pingfederate.admin.api"]
  https_host                = var.pf_base_url 
  token_url                 = var.token_url
  admin_api_path            = "/pf-admin-api/v1"
  product_version           = var.pf_version

  # The correct argument to skip SSL checks for local Docker
  insecure_trust_all_tls    = true
  x_bypass_external_validation_header = true
}


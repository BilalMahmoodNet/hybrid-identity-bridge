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
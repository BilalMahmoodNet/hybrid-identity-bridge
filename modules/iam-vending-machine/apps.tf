# This file defines the applications that the IAM Vending Machine will create in PingOne. It also includes some validation rules to enforce naming conventions and security standards for the vended clients.
# Variables are passed via the main.tf file when calling this module, allowing for flexibility and reuse across different environments or sets of applications. The module creates OAuth clients in PingFederate and corresponding groups in PingOne, and assigns appropriate roles to those groups for access management.
  variable "app_names" {
  type = map(object({
    client_id    = string
    client_name  = string
    description  = optional(string, "Vended via Identity Bridge")
    secret       = string
    grant_types  = optional(list(string), ["CLIENT_CREDENTIALS"])
    redirect_uris = optional(list(string), [])
  }))
   
# POLICY 1: Naming Converntion 
   validation {
    condition     = alltrue([
      for app in var.app_names : can(regex("^uk-", app.client_id))
    ]
    )
    error_message = "Every client_id must start with 'uk-' to comply with IAM Governance standards."
  }

# POLICY 2: Security (Secret Complexity)
  validation {
    # Check if all secrets are at least 6 characters long
    condition     = alltrue([for app in var.app_names : length(app.secret) >= 6])
    error_message = "Security Error: Client secrets must be at least 6 characters long."
  }
}

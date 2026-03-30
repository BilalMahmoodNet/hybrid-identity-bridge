variable "p1_env_id" {
  description = "PingOne Environment ID to connect to"
  type        = string
  # Provided by root module when calling this module
}

variable "cc_client_secret" {
  description = "Client Secret for the Client Credentials OAuth Client"
  type        = string
  sensitive   = true
  # Provided by root module when calling this module
}

variable "pingone_client_id" {
  description = "Client ID for the Client Credentials OAuth Client in PingOne"
  type        = string
  # Provided by root module when calling this module
}

variable "pingone_client_secret" {
  description = "Client Secret for the Client Credentials OAuth Client in PingOne"
  type        = string
  sensitive   = true
  # Provided by root module when calling this module
}

variable "adapter_password" { 
  description = "Password for the PingFederate Adapter instance used in the IdP Connection"
  type        = string
  sensitive   = true
  # Provided by root module when calling this module 
}

variable "pf_admin_host" {
  description = "PingFederate admin host"
  type        = string
}

variable "pf_user" {
  description = "PingFederate admin username"
  type        = string
}

variable "pf_pass" {
  description = "PingFederate admin password"
  type        = string
  sensitive   = true
}

variable "pingfederate_admin_password" {
  description = "Password for the PingFederate Admin user (if different from pf_pass)"
  type        = string
  sensitive   = true
  
}
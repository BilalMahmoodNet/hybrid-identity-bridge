# --- Cloud Credentials ---
variable "pingone_client_id" {
  type        = string
  description = "Worker App ID for PingOne"
}

variable "pingone_client_secret" {
  type        = string
  sensitive   = true
}

variable "pingone_environment_id" {
  type = string
}

# --- Local Docker Settings ---
variable "pf_base_url" {
  type    = string
  default = "https://localhost:9999"
}

variable "pingfederate_admin_password" {
  type      = string
  sensitive = true
}

# --- Application Specifics ---
variable "client_credentials_client_secret" {
  type      = string
  sensitive = true
}

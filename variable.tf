variable "pingone_client_secret" {
  type      = string
  sensitive = true
}

variable "pingone_client_id" {
  type = string
}

variable "pingone_environment_id" {
  type = string
}

variable "pingfederate_admin_password" {
  type      = string
  sensitive = true
}

variable "client_credentials_client_secret" {
  type      = string
  sensitive = true
}

variable "pf_base_url" {
  type    = string
  default = "https://localhost:9999"
}
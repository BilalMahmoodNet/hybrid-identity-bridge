variable "pingone_client_id" {
  type = string
}

variable "pingone_client_secret" {
  type      = string
  sensitive = true
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
  default = "https://127.0.0.1:9999"
}

variable "pf_admin_client_id" {
  type = string
}

variable "pf_admin_client_secret" {
  type      = string
  sensitive = true
}

variable "token_url" {
  type = string
}

variable "pf_version" {
  type    = string
  default = "13.0"
}

variable "pingone_region" {  
  type    = string
  default = "EU"
}
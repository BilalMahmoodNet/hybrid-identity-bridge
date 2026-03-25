variable "pingone_environment_id" {
    description = "PingOne Environment ID to connect to"
    type        = string
}

variable "client_credentials_client_secret" {
    description = "Client Secret for the Client Credentials OAuth Client"
    type        = string
    sensitive   = true
}  

variable "pingfederate_admin_password" {
  description = "Admin password for PingFederate API access"
  type        = string
  sensitive   = true
}


variable "pingone_client_id" {}
variable "pingone_client_secret" {}
variable "pingone_environment_id" {}
variable "client_credentials_client_secret" {}
variable "pf_base_url" { default = "https://localhost:9999" }


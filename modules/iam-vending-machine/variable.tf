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
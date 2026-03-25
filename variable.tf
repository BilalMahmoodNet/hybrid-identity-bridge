variable "pingone_environment_id" {
    description = "PingOne Environment ID to connect to"
    type        = string
}

variable "client_credentials_client_secret" {
    description = "Client Secret for the Client Credentials OAuth Client"
    type        = string
    sensitive   = true
}  

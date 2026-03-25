# Data source to verify PingOne connection
data "pingone_environment" "my_env" {
  environment_id = var.pingone_environment_id # Define this var in variables.tf
}

# Data source to verify PingFederate connection
 data "pingfederate_server_settings" "product_version" {}


output "hybrid_status_report" {
  value = {
    cloud_env_name = data.pingone_environment.my_env.name
    local_pf_ver   = data.pingfederate_server_settings.product_version
  }
}



resource "pingfederate_oauth_client" "cc_secret_client" {
  client_id = "cc_secret_client"
  name      = "Client Credential Group"
  enabled   = true

  client_auth = {
    type   = "SECRET"
    secret = var.client_credentials_client_secret
  }

  grant_types = ["CLIENT_CREDENTIALS"]
}

resource "pingone_group" "cc_group" {
  environment_id = var.pingone_environment_id 

  name        = pingfederate_oauth_client.cc_secret_client.name
  description = "My new awesome group for people who are awesome"

  custom_data = jsonencode({
    "client_id" = pingfederate_oauth_client.cc_secret_client.client_id
  })

  lifecycle {
    # change the `prevent_destroy` parameter value to `true` to prevent this data carrying resource from being destroyed
    prevent_destroy = false
  }
}
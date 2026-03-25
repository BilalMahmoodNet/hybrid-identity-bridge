resource "pingfederate_oauth_client" "cc_secret_client" {
  client_id = "cc_secret_client"
  name      = "Client Credential Group"
  enabled   = true

  client_auth = {
    type   = "SECRET"
    secret = var.cc_client_secret
  }

  grant_types = ["CLIENT_CREDENTIALS"]
}

resource "pingone_group" "cc_group" {
  environment_id = var.p1_env_id

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


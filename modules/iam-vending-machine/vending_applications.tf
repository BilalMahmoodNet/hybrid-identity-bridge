locals {
  p1_issuer = "https://auth.pingone.eu/${var.p1_env_id}/as"
  encoded_callback_path = base64encode(jsonencode({ "iss" = local.p1_issuer }))
  vending_machine_redirect_uri = "https://localhost:9031/sp/${local.encoded_callback_path}/cb.openid"
  idp_app_ref = one(values(pingone_application.idp_apps))
}

# Resource to create OAuth Clients (in pingfederate) based on clients.tf definition and if "is_hybrid" is true
resource "pingfederate_oauth_client" "vended_client" {

  for_each = { 
    for c in var.iam_clients : c.client_id => c 
    if !c.is_idp && !c.is_hybrid 
  }

  client_id = each.value.client_id
  name      = each.value.name
  enabled   = true
  grant_types   = each.value.grant_types
  redirect_uris = each.value.redirect_uris
  client_auth = {
    type   = "SECRET"
    # For the demo, we generate a stable secret based on the client_id
    # In Prod, we would pull this from a Vault/Secrets Manager
    secret = "${each.value.client_id}_secret_2026" 
  }
}

# Resource create all applications defined in clients.tf in PingOne
resource "pingone_application" "vended_apps" {
  for_each = { for c in var.iam_clients : c.client_id => c if !c.is_idp }
  environment_id = var.p1_env_id
  name           = each.value.name
  description =  each.value.description
  enabled        = true

  oidc_options = {
    type                       = each.value.type
    grant_types                = each.value.type == "WORKER" ? ["CLIENT_CREDENTIALS"] : ["AUTHORIZATION_CODE"]
    token_endpoint_auth_method = each.value.type == "WORKER" ? "CLIENT_SECRET_BASIC" : "NONE"
    response_types             = each.value.type == "WORKER" ? null : ["CODE"]
  }

}

resource "pingone_application" "idp_apps" {
  # Logic: Only create the App if is_idp is true
  for_each = { for c in var.iam_clients : c.client_id => c if c.is_idp }

  environment_id = var.p1_env_id
  name           = "${each.value.name}"
  enabled        = true
  

  oidc_options = {
    type           = "WEB_APP"
    redirect_uris  = [local.vending_machine_redirect_uri]
        grant_types    = ["AUTHORIZATION_CODE", "IMPLICIT"]
    response_types = ["CODE", "ID_TOKEN"]
    token_endpoint_auth_method = "CLIENT_SECRET_BASIC"
  }
}






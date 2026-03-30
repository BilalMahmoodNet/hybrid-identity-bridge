locals {
  # PingFederate escapes / as \/ in the JSON before encoding.
  # We use a double-backslash in HCL to escape the escape.
  p1_issuer = "https://auth.pingone.eu/${var.p1_env_id}/as"
  escaped_issuer = replace(local.p1_issuer, "/", "\\/")

  # 2. THE JSON PAYLOAD:
  # We manually build the JSON string to ensure no extra spaces and preserved escapes.
  json_payload = "{\"iss\":\"${local.escaped_issuer}\"}"

  raw_base64 = base64encode(local.json_payload)
  
  encoded_iss = trim(
    replace(
      replace(base64encode(local.json_payload), "+", "-"), 
      "/", "_"
    ), 
    "="
  )
  vending_machine_redirect_uri = "https://localhost:9031/sp/${local.encoded_iss}/cb.openid"
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

resource "pingone_application_flow_policy_assignment" "authentication_davinci_flow_policy_assignment" {
  for_each = pingone_application.idp_apps
  environment_id = var.p1_env_id
  application_id = each.value.id

  flow_policy_id = "283eb96818a295d776607b47d5a04ac5"

  priority = 1
}



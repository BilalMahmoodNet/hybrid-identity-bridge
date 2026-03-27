# Resource to create OAuth Clients (in pingfederate) based on clients.tf definition and if "is_hybrid" is true
resource "pingfederate_oauth_client" "vended_client" {

  for_each = {
   for k, v in var.iam_clients : k => v if v.is_hybrid
  }

  client_id = each.value.client_id
  name      = each.value.name
  enabled   = true
  grant_types   = each.value.grant_types
  redirect_uris = each.value.redirect_uris
}

# Resource create all applications defined in clients.tf in PingOne
resource "pingone_application" "vended_apps" {
  for_each = var.iam_clients
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







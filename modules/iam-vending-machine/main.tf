# This resource creates a OAuth Client in PingFederate for each entry in the app_names variable, using the provided client_id and secret

resource "pingfederate_oauth_client" "vended_client" {
  # FILTER: Only create in PingFed if is_hybrid is true
  for_each = { for k, v in var.iam_clients : k => v if v.is_hybrid }
  client_id = each.value.client_id
  name      = each.value.name
  enabled   = true
  grant_types = each.value.grant_types
  redirect_uris  = length(each.value.redirect_uris) > 0 ? each.value.redirect_uris : null
  client_auth = {
    type   = "SECRET"
    secret = each.value.secret
  }
}


resource "pingone_application" "vended_apps" {
  for_each = var.iam_clients
  environment_id = var.p1_env_id
  name           = each.value.name
  description =  each.value.description
  enabled        = true

  # STATIC BLOCK TEST: To clear the "Not Expected" error
  oidc_options = {
    # Directly use your ternary logic here
    type                       = each.value.type
    grant_types                = each.value.type == "WORKER" ? ["CLIENT_CREDENTIALS"] : ["AUTHORIZATION_CODE"]
    token_endpoint_auth_method = each.value.type == "WORKER" ? "CLIENT_SECRET_BASIC" : "NONE"
    response_types             = each.value.type == "WORKER" ? null : ["CODE"]

    
    # Ensure this is a list(string) from your map
    # oidc_scopes = each.value.oauth_scopes
  }
}



# This resource creates a PingOne Group for each vended client, and encodes the client_id as custom data for traceability
resource "pingone_group" "cc_group" {
  environment_id = var.p1_env_id

  for_each    = var.iam_clients
  name        = "Group-for-${each.value.name}"
  description = "IAM Vending Group for ${each.value.name}"
  custom_data = jsonencode({
    client_id = each.value.client_id
  })

  lifecycle {
    prevent_destroy = false
  }
}





# This resource assigns the "Identity Data Admin" role to each group created for the vended clients, scoped to the environment level
resource "pingone_group_role_assignment" "default_assignment" {
  for_each = var.iam_clients

  environment_id = var.p1_env_id
  group_id       = pingone_group.cc_group[each.key].id
  role_id = data.pingone_role.identity_data_admin.id
  scope_environment_id = var.p1_env_id 
}

# Find the Role ID by Name
data "pingone_role" "identity_data_admin" {
  name = "Identity Data Admin"
}
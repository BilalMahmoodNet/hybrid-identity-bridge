# This resource creates a OAuth Client in PingFederate for each entry in the app_names variable, using the provided client_id and secret
resource "pingfederate_oauth_client" "vended_client" {
  for_each  = var.app_names
  client_id = each.value.client_id
  name      = each.value.client_name
  enabled   = true
  grant_types = each.value.grant_types
  redirect_uris  = length(each.value.redirect_uris) > 0 ? each.value.redirect_uris : null
  client_auth = {
    type   = "SECRET"
    secret = each.value.secret
  }
}

# This resource creates a PingOne Group for each vended client, and encodes the client_id as custom data for traceability
resource "pingone_group" "cc_group" {
  environment_id = var.p1_env_id

  for_each    = var.app_names
  name        = pingfederate_oauth_client.vended_client[each.key].name
  description = each.value.description

  custom_data = jsonencode({
    "client_id" = pingfederate_oauth_client.vended_client[each.key].client_id
  })

  lifecycle {
    prevent_destroy = false
  }
}


# This resource assigns the "Identity Data Admin" role to each group created for the vended clients, scoped to the environment level
resource "pingone_group_role_assignment" "default_assignment" {
  for_each = var.app_names

  environment_id = var.p1_env_id
  group_id       = pingone_group.cc_group[each.key].id
  role_id = data.pingone_role.identity_data_admin.id
  scope_environment_id = var.p1_env_id 
}

# Find the Role ID by Name
data "pingone_role" "identity_data_admin" {
  name = "Identity Data Admin"
}
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
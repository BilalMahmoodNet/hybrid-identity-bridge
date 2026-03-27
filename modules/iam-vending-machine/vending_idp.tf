resource "pingfederate_sp_adapter" "vending_machine_adapter" {
  count = anytrue([for client in var.iam_clients : client.is_hybrid]) ? 1 : 0

  adapter_id = "vend1"
  name       = "P1 IDP Adapter"

  plugin_descriptor_ref = {
    id = "com.pingidentity.adapters.opentoken.SpAuthnAdapter"
  }

  configuration = {
    sensitive_fields = [
      { name = "Password", value = var.adapter_password },
      { name = "Confirm Password", value = var.adapter_password }
    ]
    fields = [
      { name = "Transport Mode", value = "1" },      
      { name = "Token Name", value = "opentoken" },
      { name = "Cipher Suite", value = "1" },       
      { name = "Token Lifetime", value = "300" },
      { name = "Session Lifetime", value = "43200" },
      { name = "Secure Cookie", value = "true" },
      { name = "HTTP Only Flag", value = "true" },
      { name = "URL Encode Cookie Values", value = "true" }
    ]
  }

  attribute_contract = {
    extended_attributes = [
      { name = "email" },
      { name = "firstName" },
      { name = "lastName" }
    ]
  }
}


resource "pingfederate_sp_idp_connection" "p1_connection" {
  count = length(pingone_application.idp_apps) > 0 ? 1 : 0

  name      = "PingOne-Hybrid-Bridge"
  entity_id = local.p1_issuer
  active    = true

  oidc_client_credentials = {
    client_id = values(pingone_application.idp_apps)[0].id
    client_secret = var.pingone_client_secret 
  }

  idp_browser_sso = {
    # REQUIRED SCHEMA FIELDS: The "Principal" fix
    protocol             = "OIDC"
    idp_identity_mapping = "ACCOUNT_MAPPING"

   oidc_provider_settings = {
      client_id = values(pingone_application.idp_apps)[0].id
      client_secret = var.pingone_client_secret 
      authorization_endpoint = "${local.p1_issuer}/authorize"
      jwks_url               = "${local.p1_issuer}/jwks"
      scopes                 = "openid profile email"
      login_type             = "POST"
    }



    attribute_contract = {
      extended_attributes = [
        { name = "given_name" }, 
        { name = "family_name" }, 
        { name = "email" }
      ]
    }

    adapter_mappings = [{
      sp_adapter_ref = { id = "vend1" }
      attribute_contract_fulfillment = {
        "firstName" = { source = { type = "CLAIMS" }, value = "given_name" }
        "lastName"  = { source = { type = "CLAIMS" }, value = "family_name" }
        "email"     = { source = { type = "CLAIMS" }, value = "email" }
        "subject"   = { source = { type = "CLAIMS" }, value = "sub" }
      }
    }]
  }
}
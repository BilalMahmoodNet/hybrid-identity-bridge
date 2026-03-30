# To be used in iterim as the pingfederate_authentication_policies has a bug

resource "terracurl_request" "vended_policy_bypass" {
  name            = "pingfed_auth_policy"
  url             = "https://127.0.0.1:9999/pf-admin-api/v1/authenticationPolicies/policy"
  method          = "POST"
  
  skip_tls_verify = true 
  ca_cert_file    = ""

  response_codes = [200, 201, 204]

  headers = {
    "Content-Type"  = "application/json"
    "X-XSRF-Header" = "PingFederate"
    "Authorization" = "Basic ${base64encode("Admin:${var.pingfederate_admin_password}")}"
  }

  request_body = jsonencode(
    {
      "name": "P1 IDP Bridge",
      "enabled": true,
      "rootNode": {
        "action": {
          "type": "AUTHN_SOURCE",
          "authenticationSource": {
            "type": "IDP_CONNECTION",
            "sourceRef": { "id": "ZmvxDAFIZi3EIJo6cDSFfnqCbQz" }
          }
        },
        "children": [
          {
            "action": {
              "type": "DONE",
              "context": "Fail"
            }
          }, 
          {
            "action": {
              "type": "APC_MAPPING",
              "context": "Success",
              "authenticationPolicyContractRef": { "id": "sWL0JS24KwA7CzDa" },
              "attributeMapping": {
                "attributeContractFulfillment": {
                  "subject": { "source": { "type": "IDP_CONNECTION", "id": "ZmvxDAFIZi3EIJo6cDSFfnqCbQz" }, "value": "sub" },
                  "given_name": { "source": { "type": "IDP_CONNECTION", "id": "ZmvxDAFIZi3EIJo6cDSFfnqCbQz" }, "value": "given_name" },
                  "family_name": { "source": { "type": "IDP_CONNECTION", "id": "ZmvxDAFIZi3EIJo6cDSFfnqCbQz" }, "value": "family_name" },
                  "email": { "source": { "type": "IDP_CONNECTION", "id": "ZmvxDAFIZi3EIJo6cDSFfnqCbQz" }, "value": "email" }
                }
              }
            }
          }
        ]
      }
    }
  )

  depends_on = [pingfederate_sp_idp_connection.p1_connection]
}



# has a bug atm
# resource "pingfederate_authentication_policies" "global_logic" {
#   # Top-level settings to ensure the 'Settings' object is fully defined
#   fail_if_no_selection = false
#   authn_selection_trees = [
#     {
#       name    = "P1 IDP Bridge"
#       enabled = true

#       root_node = {
#         action = {
#           authn_source_policy_action = {
#             # THE MACHINE: Your PingOne Connection ID
#             idp_connection_id = "ZmvxDAFIZi3EIJo6cDSFfnqCbQz"
#           }
#         }

#         children = [
#           {
#             # First Child: The 'Failure' path
#             result = "Failure"
#             action = {
#               done_policy_action = {
#                 context = "Fail"
#               }
#             }
#           },
#           {
#             # Second Child: The 'Success' path
#             result = "Success"
#             action = {
#               apc_mapping_policy_action = {
#                 authentication_policy_contract_ref = {
#                   id = "sWL0JS24KwA7CzDa"
#                 }
#                 attribute_mapping = {
#                   attribute_contract_fulfillment = {
#                     "subject"     = { source = { type = "IDP_CONNECTION" }, value = "sub" }
#                     "given_name"  = { source = { type = "IDP_CONNECTION" }, value = "given_name" }
#                     "family_name" = { source = { type = "IDP_CONNECTION" }, value = "family_name" }
#                     "email"       = { source = { type = "IDP_CONNECTION" }, value = "email" }
#                   }
#                 }
#               }
#             }
#           }
#         ]
#       }
#     }
#   ]
# }
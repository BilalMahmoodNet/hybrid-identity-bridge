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

module "cc_iam_vending_machine" {
  source   = "./modules/iam-vending-machine"
  p1_env_id              = var.pingone_environment_id
  cc_client_secret     = var.client_credentials_client_secret

  app_names = {
    "uk-chatbot-prod" = {
      client_id   = "uk-chatbot-dev"
      client_name = "AI Chatbot Service"
      description = "OAuth client for the AI Chatbot service, vended via Identity Bridge - client credentials flow for machine-to-machine communication"
      secret      = var.client_credentials_client_secret
      grant_types = ["CLIENT_CREDENTIALS"] # Machine account
    },
    "uk-web-portal" = {
      client_id     = "uk-web-portal"
      client_name   = "Customer Web Portal"
      description   = "OAuth client for the Customer Web Portal, vended via Identity Bridge - authorization code flow for human users"
      secret        = var.client_credentials_client_secret
      grant_types   = ["AUTHORIZATION_CODE", "REFRESH_TOKEN"] # Human account
      redirect_uris = ["https://portal.uk.example.com/callback"]
    }
  } 

}

output "vending_machine_group_id" {
  value = module.cc_iam_vending_machine.iam_vending_machine_report
} 
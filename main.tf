# Data source to verify PingOne connection
data "pingone_environment" "my_env" {
  environment_id = var.pingone_environment_id # Define this var in variables.tf
}

# Data source to verify PingFederate connection - removed to prevent failing github actions workflow due to locl PF connection issues
 #data "pingfederate_server_settings" "product_version" {}


output "hybrid_status_report" {
  value = {
    cloud_env_name = data.pingone_environment.my_env.name
   # local_pf_ver   = data.pingfederate_server_settings.product_version
  }
}

module "cc_iam_vending_machine" {
  source   = "./modules/iam-vending-machine"
  p1_env_id            = var.pingone_environment_id
  cc_client_secret     = var.client_credentials_client_secret
  pingone_client_id = var.pingone_client_id
  pingone_client_secret = var.pingone_client_secret
  adapter_password = var.adapter_password
  pf_admin_host = var.pf_base_url
  pf_user = var.pf_admin_client_id
  pf_pass = var.pf_admin_client_secret
  pingfederate_admin_password = var.pingfederate_admin_password
  

}

output "vending_machine_group_id" {
  value = module.cc_iam_vending_machine.iam_vending_machine_report
} 
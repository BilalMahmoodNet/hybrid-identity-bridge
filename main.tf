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
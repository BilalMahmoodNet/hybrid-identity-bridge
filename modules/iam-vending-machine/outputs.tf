output "iam_vending_machine_report" {
  description = "ID of the group created in PingOne for the Client Credential OAuth Client"
  value       = pingone_group.cc_group.id
}
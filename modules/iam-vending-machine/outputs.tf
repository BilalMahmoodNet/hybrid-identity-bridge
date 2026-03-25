output "iam_vending_machine_report" {
  description = "Map of Client IDs to their corresponding PingOne Group IDs"
  # This 'for' loop transforms the resource map into a simple ID map
  value = {
    for k, group in pingone_group.cc_group : k => group.id
  }
}
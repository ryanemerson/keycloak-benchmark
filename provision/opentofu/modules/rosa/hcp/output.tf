output "input_cluster_name" {
  value       = var.cluster_name
  description = "The name of the created ROSA hosted control planes cluster."
}

output "input_region" {
  value       = var.region
  description = "The region AWS resources created in."
}

output "input_availability_zones" {
  value       = var.availability_zones
  description = "The Availability Zones AWS resources created in."
}

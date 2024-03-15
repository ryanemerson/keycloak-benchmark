output "input_region" {
  value       = var.region
  description = "AWS region resources created in."
}

output "input_cluster_name" {
  value       = var.cluster_name
  description = "Name of the created ROSA with hosted control planes cluster."
}

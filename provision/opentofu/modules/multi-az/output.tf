output "input_cluster_prefix" {
  value       = var.cluster_prefix
  description = "The prefix to be used when creating HCP clusters."
}

output "input_region" {
  value       = var.region
  description = "The region AWS resources created in."
}

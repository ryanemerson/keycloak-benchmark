output "input_cluster_prefix" {
  value       = var.cluster_prefix
  description = "The prefix to be used when creating HCP clusters."
}

output "input_region" {
  value       = var.region
  description = "The region AWS resources created in."
}

output "cluster_a_kube_context" {
  value = module.rosa_cluster_a.kube_context
  description = "The kubeconfig context for ROSA cluster A."
}

output "cluster_b_kube_context" {
  value = module.rosa_cluster_b.kube_context
  description = "The kubeconfig context for ROSA cluster B."
}

module rosa_cluster_a {
  source = "../../openshift-dependencies"

  kube_context = var.kube_context_a
}

module rosa_cluster_b {
  source = "../../openshift-dependencies"

  kube_context = var.kube_context_b
}

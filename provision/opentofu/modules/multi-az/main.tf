data "external" "rosa" {
  program = [
    "bash", "${path.module}/scripts/rosa_machine_cidr.sh"
  ]
  query = {
    cluster_name = var.cluster_prefix
  }
}

module rosa_cluster_a {
  source = "../rosa/hcp"

  cluster_name = "${var.cluster_prefix}-a"
  openshift_version = var.openshift_version
  instance_type = var.instance_type
  region = var.region
  replicas = var.replicas
  rhcs_token = var.rhcs_token
  subnet_cidr_prefix = 28
  vpc_cidr = data.external.rosa.result.cidr_a
}

module rosa_cluster_b {
  source = "../rosa/hcp"

  cluster_name = "${var.cluster_prefix}-b"
  openshift_version = var.openshift_version
  instance_type = var.instance_type
  region = var.region
  replicas = var.replicas
  rhcs_token = var.rhcs_token
  subnet_cidr_prefix = 28
  vpc_cidr = data.external.rosa.result.cidr_b
}

#module rosa_dependencies_a {
#  source = "../openshift-dependencies"
#
#  providers {
#    kubernetes = {
#      config_path = module.rosa_cluster_a.kubeconfig
#    }
#  }
#}
#
#module rosa_dependencies_b {
#  source = "../openshift-dependencies"
#
#  providers {
#    kubernetes = {
#      config_path = module.rosa_cluster_b.kubeconfig
#    }
#  }
#}

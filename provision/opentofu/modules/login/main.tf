locals {
  cluster_name = "gh-keycloak-b"
}

resource "null_resource" "create_admin" {
  provisioner "local-exec" {
    command     = "./scripts/rosa_oc_login.sh"
    environment = {
      KUBECONFIG = "${path.module}/${local.cluster_name}"
      CLUSTER_NAME = local.cluster_name
    }
    interpreter = ["bash"]
    working_dir = path.module
  }
}

resource "local_file" "kubeconfig" {
  depends_on = [null_resource.create_admin]

  filename = "${path.module}/${local.cluster_name}"
  source = "${path.module}/${local.cluster_name}"
}
output "kubeconfig" {
  value = abspath("${path.module}/${local.cluster_name}")
}

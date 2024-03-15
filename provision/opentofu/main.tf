module "vpc" {
    source = "./hcp/vpc"

    region = var.region
    cluster_name = var.cluster_name
}

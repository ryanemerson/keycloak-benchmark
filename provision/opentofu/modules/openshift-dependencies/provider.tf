terraform {
  backend "s3" {
    bucket         = "kcb-tf-state"
    key            = "vpc"
    region         = "eu-west-1"
    encrypt        = true
    dynamodb_table = "app-state"
  }

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.27.0"
    }
  }

  required_version = ">= 1.4.0"
}

provider "kubernetes" {
  config_path    = var.kube_config
  config_context = var.kube_context
}

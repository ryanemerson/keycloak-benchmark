terraform {
  backend "s3" {
    bucket = "kcb-tf-state"
    key    = "vpc"
    region = "eu-west-1"
    encrypt = true
    dynamodb_table = "app-state"
  }

  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2"
    }
  }

  required_version = ">= 1.4.0"
}

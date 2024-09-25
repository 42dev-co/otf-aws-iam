terraform {
  backend "s3" {
    bucket = "iac.example.com"
    key    = "example/otf-aws-iam/state.tfstate"
    region = "ap-southeast-1"
    profile = "devops"
  }
}

provider "aws" {
  region = var.region
}

variable "region" {
  default = "ap-southeast-1"
}

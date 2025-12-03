terraform {
  backend "s3" {
    bucket  = "desafio-sre-junior-tfstate-870205216049"
    key     = "iam/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}

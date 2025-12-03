terraform {
  backend "s3" {
    bucket  = "desafio-sre-junior-tfstate-870205216049"
    key     = "vpc/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}

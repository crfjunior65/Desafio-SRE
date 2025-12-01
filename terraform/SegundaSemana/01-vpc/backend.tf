terraform {
  backend "s3" {
    bucket  = "desafio-sre-tfstate-387146597296"
    key     = "vpc/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}

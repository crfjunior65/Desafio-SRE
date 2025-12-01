terraform {
  backend "s3" {
    bucket  = "desafio-sre-tfstate-387146597296"
    key     = "rds/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}

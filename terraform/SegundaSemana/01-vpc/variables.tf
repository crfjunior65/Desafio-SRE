variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "region_state" {
  description = "Região onde estão armazenados os state files do Terraform"
  type        = string
  #default     = "us-east-1"
}

variable "vpc_cidr" {
  type = string
}

variable "availability_zones" {
  type = list(string)
}

variable "region" {
  type = string
}

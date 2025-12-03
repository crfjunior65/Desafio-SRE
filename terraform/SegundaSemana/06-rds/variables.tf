variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "region" {
  type = string
}

variable "state_bucket" {
  type = string
}

variable "rds_instance_class" {
  type = string
}

variable "rds_engine" {
  type = string
}

variable "rds_engine_version" {
  type = string
}

variable "region_state" {
  description = "Região onde estão armazenados os state files do Terraform"
  type        = string
  #default     = "us-east-1"
}

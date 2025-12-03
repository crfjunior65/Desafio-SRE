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

variable "opensearch_instance_type" {
  type = string
}

variable "opensearch_version" {
  type = string
}

variable "opensearch_master_password" {
  type      = string
  sensitive = true
}

variable "region_state" {
  description = "Região onde estão armazenados os state files do Terraform"
  type        = string
  #default     = "us-east-1"
}

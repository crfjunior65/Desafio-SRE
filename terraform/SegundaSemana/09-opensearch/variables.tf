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

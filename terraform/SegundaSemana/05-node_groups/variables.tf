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

variable "node_groups" {
  type = map(object({
    instance_types = list(string)
    capacity_type  = string
    desired_size   = number
    min_size       = number
    max_size       = number
  }))
}

variable "region_state" {
  description = "Região onde estão armazenados os state files do Terraform"
  type        = string
  #default     = "us-east-1"
}

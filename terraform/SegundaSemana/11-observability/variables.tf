variable "project_name" {
  description = "Nome do projeto"
  type        = string
}

variable "environment" {
  description = "Ambiente (production, staging, development)"
  type        = string
}

variable "region" {
  description = "Região AWS"
  type        = string
}

variable "region_state" {
  description = "Região onde estão armazenados os state files do Terraform"
  type        = string
}

variable "state_bucket" {
  description = "Bucket S3 para armazenar o state do Terraform"
  type        = string
}

# Observability specific variables
variable "grafana_admin_password" {
  description = "Senha do admin do Grafana"
  type        = string
  default     = "admin123"
}

variable "prometheus_retention" {
  description = "Tempo de retenção das métricas do Prometheus"
  type        = string
  default     = "7d"
}

variable "prometheus_storage_size" {
  description = "Tamanho do storage do Prometheus"
  type        = string
  default     = "10Gi"
}

variable "grafana_storage_size" {
  description = "Tamanho do storage do Grafana"
  type        = string
  default     = "5Gi"
}

variable "jaeger_storage_size" {
  description = "Tamanho do storage do Jaeger Elasticsearch"
  type        = string
  default     = "5Gi"
}

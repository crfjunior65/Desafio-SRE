variable "app_port" {
  description = "Porta da aplicação Flask"
  type        = number
  default     = 5000
}

variable "metrics_port" {
  description = "Porta das métricas Prometheus"
  type        = number
  default     = 9999
}

variable "redis_port" {
  description = "Porta do Redis"
  type        = number
  default     = 6379
}

variable "postgres_port" {
  description = "Porta do PostgreSQL"
  type        = number
  default     = 5432
}

variable "postgres_password" {
  description = "Senha do PostgreSQL"
  type        = string
  default     = "senhafacil"
  sensitive   = true
}

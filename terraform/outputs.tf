# Outputs para facilitar acesso
output "app_url" {
  description = "URL da aplicação"
  value       = "http://localhost:5000"
}

output "metrics_url" {
  description = "URL das métricas Prometheus"
  value       = "http://localhost:9999/metrics"
}

output "redis_host" {
  description = "Host do Redis"
  value       = "localhost:6379"
}

output "postgres_host" {
  description = "Host do PostgreSQL"
  value       = "localhost:5432"
}

output "network_name" {
  description = "Nome da rede Docker"
  value       = docker_network.app_network.name
}

output "container_ids" {
  description = "IDs dos containers"
  value = {
    app      = docker_container.app.id
    redis    = docker_container.redis.id
    postgres = docker_container.postgres.id
  }
}

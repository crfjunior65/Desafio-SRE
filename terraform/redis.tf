# Imagem Redis
resource "docker_image" "redis" {
  name         = "redis:7-alpine"
  keep_locally = false
}

# Container Redis
resource "docker_container" "redis" {
  name  = "terraform-redis"
  image = docker_image.redis.image_id

  # Restart policy
  restart = "unless-stopped"

  # Portas
  ports {
    internal = 6379
    external = 6379
    ip       = "0.0.0.0"
  }

  # Rede
  networks_advanced {
    name = docker_network.app_network.name
  }

  # Healthcheck
  healthcheck {
    test     = ["CMD", "redis-cli", "ping"]
    interval = "10s"
    timeout  = "3s"
    retries  = 3
  }
}

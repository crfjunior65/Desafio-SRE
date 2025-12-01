# Imagem PostgreSQL
resource "docker_image" "postgres" {
  name         = "postgres:15-alpine"
  keep_locally = false
}

# Container PostgreSQL
resource "docker_container" "postgres" {
  name  = "terraform-postgres"
  image = docker_image.postgres.image_id

  restart = "unless-stopped"

  # Portas
  ports {
    internal = 5432
    external = 5432
    ip       = "0.0.0.0"
  }

  # Variáveis de ambiente
  env = [
    "POSTGRES_PASSWORD=senhafacil",
    "POSTGRES_DB=postgres",
    "POSTGRES_USER=postgres"
  ]

  # Volume
  volumes {
    volume_name    = docker_volume.postgres_data.name
    container_path = "/var/lib/postgresql/data"
  }

  # Rede
  networks_advanced {
    name = docker_network.app_network.name
  }

  # Healthcheck
  healthcheck {
    test     = ["CMD-SHELL", "pg_isready -U postgres"]
    interval = "10s"
    timeout  = "3s"
    retries  = 3
  }
}

# Imagem da aplicação (precisa ser construída antes)
resource "docker_image" "app" {
  name         = "flask-app:latest"
  keep_locally = true

  # Força rebuild se Dockerfile mudar
  triggers = {
    dockerfile_hash = filemd5("${path.module}/../Dockerfile")
    app_hash        = filemd5("${path.module}/../app/app.py")
  }
}

# Container da aplicação
resource "docker_container" "app" {
  name  = "terraform-flask-app"
  image = docker_image.app.image_id

  restart = "unless-stopped"

  # Portas
  ports {
    internal = 5000
    external = 5000
    ip       = "0.0.0.0"
  }

  ports {
    internal = 9999
    external = 9999
    ip       = "0.0.0.0"
  }

  # Variáveis de ambiente
  env = [
    "REDIS_HOST=terraform-redis",
    "POSTGRES_HOST=terraform-postgres"
  ]

  # Rede
  networks_advanced {
    name = docker_network.app_network.name
  }

  # Dependências explícitas
  depends_on = [
    docker_container.redis,
    docker_container.postgres
  ]
}

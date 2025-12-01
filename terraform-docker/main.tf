terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {}

resource "docker_network" "app_network" {
  name = "app-network-tf"
}

resource "docker_image" "redis" {
  name = "redis:7-alpine"
}

resource "docker_container" "redis" {
  name  = "redis-tf"
  image = docker_image.redis.image_id
  networks_advanced {
    name = docker_network.app_network.name
  }
}

resource "docker_image" "postgres" {
  name = "postgres:15-alpine"
}

resource "docker_container" "postgres" {
  name  = "postgres-tf"
  image = docker_image.postgres.image_id
  env   = ["POSTGRES_PASSWORD=senhafacil"]
  networks_advanced {
    name = docker_network.app_network.name
  }
}

resource "docker_image" "app" {
  name = "app-primeira:v1"
  build {
    context    = "../app-Primeira"
    dockerfile = "Dockerfile"
  }
}

resource "docker_container" "app" {
  name  = "app-primeira-tf"
  image = docker_image.app.image_id
  env = [
    "REDIS_HOST=redis-tf",
    "POSTGRES_HOST=postgres-tf",
    "POSTGRES_PASSWORD=senhafacil"
  ]
  ports {
    internal = 5000
    external = 5000
  }
  ports {
    internal = 9999
    external = 9999
  }
  networks_advanced {
    name = docker_network.app_network.name
  }
  depends_on = [
    docker_container.redis,
    docker_container.postgres
  ]
}

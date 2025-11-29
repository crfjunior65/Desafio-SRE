terraform {
  required_version = ">= 1.0"

  # Providers necessários
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

# Configuração do provider Docker
provider "docker" {
  host = "unix:///var/run/docker.sock"
}

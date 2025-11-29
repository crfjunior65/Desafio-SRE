# Rede Docker customizada
resource "docker_network" "app_network" {
  name   = "terraform-app-network"
  driver = "bridge"

  ipam_config {
    subnet  = "172.20.0.0/16"
    gateway = "172.20.0.1"
  }
}

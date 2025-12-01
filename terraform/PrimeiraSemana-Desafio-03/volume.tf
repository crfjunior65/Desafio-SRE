# Volume para persistência do PostgreSQL
resource "docker_volume" "postgres_data" {
  name = "terraform-postgres-data"
}

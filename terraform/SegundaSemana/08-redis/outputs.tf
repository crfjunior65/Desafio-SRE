output "redis_endpoint" {
  value = aws_elasticache_replication_group.main.configuration_endpoint_address
}

output "redis_port" {
  value = aws_elasticache_replication_group.main.port
}

output "redis_reader_endpoint" {
  value = aws_elasticache_replication_group.main.reader_endpoint_address
}

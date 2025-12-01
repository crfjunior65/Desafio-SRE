output "kafka_arn" {
  value = aws_msk_cluster.main.arn
}

output "kafka_bootstrap_brokers_tls" {
  value = aws_msk_cluster.main.bootstrap_brokers_tls
}

output "kafka_zookeeper_connect_string" {
  value = aws_msk_cluster.main.zookeeper_connect_string
}

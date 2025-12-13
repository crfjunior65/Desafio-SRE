output "prometheus_stack_status" {
  description = "Status do Prometheus Stack"
  value       = helm_release.prometheus_stack.status
}

output "jaeger_status" {
  description = "Status do Jaeger"
  value       = helm_release.jaeger.status
}

output "opentelemetry_collector_status" {
  description = "Status do OpenTelemetry Collector"
  value       = helm_release.opentelemetry_collector.status
}

output "fluent_bit_status" {
  description = "Status do Fluent Bit"
  value       = helm_release.fluent_bit.status
}

output "fluent_bit_role_arn" {
  description = "ARN da IAM Role do Fluent Bit"
  value       = aws_iam_role.fluent_bit_role.arn
}

output "monitoring_namespace" {
  description = "Namespace de monitoramento"
  value       = kubernetes_namespace.monitoring.metadata[0].name
}

output "tracing_namespace" {
  description = "Namespace de tracing"
  value       = kubernetes_namespace.tracing.metadata[0].name
}

output "logging_namespace" {
  description = "Namespace de logging"
  value       = kubernetes_namespace.logging.metadata[0].name
}

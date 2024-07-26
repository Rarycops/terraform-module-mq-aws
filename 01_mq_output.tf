output "mq_configuration_arn" {
  description = "ARN of the configuration."
  value       = try(aws_mq_configuration.mq_configuration[0].arn, null)
}

output "mq_configuration_id" {
  description = "Unique ID that Amazon MQ generates for the configuration."
  value       = try(aws_mq_configuration.mq_configuration[0].id, null)
}

output "mq_configuration_latest_revision" {
  description = "Latest revision of the configuration."
  value       = try(aws_mq_configuration.mq_configuration[0].latest_revision, null)
}

output "mq_configuration_tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = try(aws_mq_configuration.mq_configuration[0].tags_all, null)
}

output "mq_broker_arn" {
  description = "ARN of the broker."
  value       = aws_mq_broker.mq_broker.arn
}

output "mq_broker_id" {
  description = "Unique ID that Amazon MQ generates for the broker."
  value       = aws_mq_broker.mq_broker.id
}

output "mq_broker_instances_console_url" {
  description = "The URL of the ActiveMQ Web Console or the RabbitMQ Management UI depending on engine_type."
  value       = aws_mq_broker.mq_broker.instances.0.console_url
}

output "mq_broker_instances_ip_address" {
  description = "IP Address of the broker."
  value       = aws_mq_broker.mq_broker.instances.0.ip_address
}

output "mq_broker_instances_endpoints" {
  description = "Broker's wire-level protocol endpoints in the following order & format referenceable e.g., as instances.0.endpoints.0"
  value       = aws_mq_broker.mq_broker.instances.0.endpoints
}

output "mq_broker_pending_data_replication_mode" {
  description = "The data replication mode that will be applied after reboot."
  value       = aws_mq_broker.mq_broker.pending_data_replication_mode
}

output "mq_broker_tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_mq_broker.mq_broker.tags_all
}

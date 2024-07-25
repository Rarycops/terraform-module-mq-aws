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

#TODO mq broker outputs

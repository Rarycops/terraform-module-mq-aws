output "activemq_ip_address" {
  value = module.mq_broker_activemq.mq_broker_instances_ip_address
}

output "rabbitmq_ip_address" {
  value = module.mq_broker_rabbitmq.mq_broker_instances_ip_address
}

output "activemq_endpoints" {
  value = module.mq_broker_activemq.mq_broker_instances_endpoints
}

output "rabbitmq_endpoints" {
  value = module.mq_broker_rabbitmq.mq_broker_instances_endpoints
}

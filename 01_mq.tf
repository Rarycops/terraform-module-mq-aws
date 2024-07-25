# Creation of the broker
resource "aws_mq_broker" "mq_broker" {
  depends_on = [aws_mq_configuration.mq_configuration]

  broker_name                         = var.mq_broker_broker_name
  engine_type                         = var.mq_broker_engine_type
  engine_version                      = var.mq_broker_engine_resion
  host_instance_type                  = var.mq_broker_host_instance_type
  apply_immediately                   = var.mq_broker_apply_immediately
  authentication_strategy             = var.mq_broker_authentication_strategy
  auto_minor_version_upgrade          = var.mq_broker_auto_minor_version_upgrade
  data_replication_mode               = var.mq_broker_data_replication_mode
  data_replication_primary_broker_arn = var.mq_broker_data_replication_primary_broker_arn
  deployment_mode                     = var.mq_broker_deployment_mode
  dynamic "user" {
    for_each = var.mq_broker_user_map
    content {
      console_access   = user.value.console_access
      groups           = user.value.groups
      password         = user.value.password
      replication_user = user.value.replication_user
      username         = user.value.username
    }
  }
  dynamic "configuration" {
    for_each = (var.mq_broker_configuration_revision != null && var.mq_broker_configuration_id != null) ? [1] : (var.mq_configuration_data != null) ? [1] : []
    content {
      id       = var.mq_broker_configuration_id != null ? var.mq_broker_configuration_id : aws_mq_configuration.mq_configuration[0].id
      revision = var.mq_broker_configuration_revision != null ? var.mq_broker_configuration_revision : aws_mq_configuration.mq_configuration[0].latest_revision
    }
  }
  encryption_options {
    kms_key_id        = var.mq_broker_encryption_options_kms_key_id
    use_aws_owned_key = var.mq_broker_encryption_options_use_aws_owned_key
  }
  #TODO finish
}

resource "aws_mq_configuration" "mq_configuration" {
  count = var.mq_configuration_data != null ? 1 : 0

  data                    = var.mq_configuration_data
  engine_type             = var.mq_broker_engine_type
  engine_version          = var.mq_broker_engine_resion
  name                    = var.mq_configuration_name != null ? var.mq_configuration_name : var.mq_broker_broker_name
  authentication_strategy = var.mq_broker_authentication_strategy
  description             = var.mq_configuration_description
  tags                    = merge(var.general_tags, var.mq_configuration_tags)
}

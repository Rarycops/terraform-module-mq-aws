variable "mq_broker_broker_name" {
  description = " Name of the broker."
  type        = string
}

variable "mq_broker_engine_type" {
  description = "Type of broker engine. Valid values are ActiveMQ and RabbitMQ."
  type        = string
}

variable "mq_broker_engine_resion" {
  description = "Version of the broker engine."
  type        = string
}

variable "mq_broker_host_instance_type" {
  description = "Broker's instance type."
  type        = string
}

variable "mq_broker_user_map" {
  description = "Configuration block for broker users. For engine_type of RabbitMQ, Amazon MQ does not return broker users preventing this resource from making user updates and drift detection."
  type = map(object({
    username         = string
    password         = string
    console_access   = bool
    groups           = list(string)
    replication_user = bool
  }))
}

variable "mq_broker_apply_immediately" {
  description = "Specifies whether any broker modifications are applied immediately, or during the next maintenance window."
  type        = bool
  default     = false
}

variable "mq_broker_authentication_strategy" {
  description = "Authentication strategy used to secure the broker."
  type        = string
  default     = null
  validation {
    condition     = (var.mq_broker_engine_type == "RabbitMQ" && var.mq_broker_authentication_strategy == "simple") || (var.mq_broker_engine_type != "RabbitMQ" && (var.mq_broker_authentication_strategy == "ldap" || var.mq_broker_authentication_strategy == "simple")) || (var.mq_broker_authentication_strategy == null)
    error_message = "Valid values are simple and ldap. ldap is not supported for engine_type RabbitMQ."
  }
}

variable "mq_broker_auto_minor_version_upgrade" {
  description = "Whether to automatically upgrade to new minor versions of brokers as Amazon MQ makes releases available."
  type        = bool
  default     = false
}

variable "mq_broker_configuration_revision" {
  description = "Revision of the Configuration."
  type        = number
  default     = null
}

variable "mq_broker_configuration_id" {
  description = "The Configuration ID."
  type        = string
  default     = null
  validation {
    condition     = (var.mq_broker_configuration_id != null && var.mq_broker_configuration_revision != null) || var.mq_broker_configuration_id == null
    error_message = "mq_broker_configuration_revision is needed if mq_broker_configuration_id is set"
  }
}

variable "mq_configuration_data" {
  description = "Broker configuration in XML format for ActiveMQ or Cuttlefish format for RabbitMQ."
  type        = string
  default     = null
}

variable "mq_configuration_name" {
  description = "Name of the configuration. If mq_configuration_name is not provided the configuration name will be the same as the mq_broker_broker_name"
  type        = string
  default     = null
}

variable "mq_configuration_description" {
  description = "Description of the configuration."
  type        = string
  default     = null
}

variable "mq_configuration_tags" {
  description = "Map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "mq_broker_data_replication_mode" {
  description = "Defines whether this broker is a part of a data replication pair."
  type        = string
  default     = "NONE"
  validation {
    condition     = var.mq_broker_data_replication_mode == "CRDR" || var.mq_broker_data_replication_mode == "NONE"
    error_message = "mq_broker_data_replication_mode valid values are CRDR and NONE."
  }
}

variable "mq_broker_data_replication_primary_broker_arn" {
  description = "The Amazon Resource Name (ARN) of the primary broker that is used to replicate data from in a data replication pair, and is applied to the replica broker."
  type        = string
  default     = null
  validation {
    condition     = (var.mq_broker_data_replication_primary_broker_arn != null && var.mq_broker_data_replication_mode == "CRDR") || (var.mq_broker_data_replication_primary_broker_arn == null && var.mq_broker_data_replication_mode == "NONE")
    error_message = "mq_broker_data_replication_primary_broker_arn must be set when data_replication_mode is CRDR."
  }
}

variable "mq_broker_deployment_mode" {
  description = "Deployment mode of the broker."
  type        = string
  default     = "SINGLE_INSTANCE"
  validation {
    condition     = var.mq_broker_deployment_mode == "SINGLE_INSTANCE" || var.mq_broker_deployment_mode == "ACTIVE_STANDBY_MULTI_AZ" || var.mq_broker_deployment_mode == "CLUSTER_MULTI_AZ"
    error_message = "mq_broker_deployment_mode valid values are SINGLE_INSTANCE, ACTIVE_STANDBY_MULTI_AZ, and CLUSTER_MULTI_AZ. "
  }
}

variable "mq_broker_encryption_options_kms_key_id" {
  description = "Amazon Resource Name (ARN) of Key Management Service (KMS) Customer Master Key (CMK) to use for encryption at rest."
  type        = string
  default     = null
  validation {
    condition     = (var.mq_broker_encryption_options_use_aws_owned_key == false && var.mq_broker_encryption_options_kms_key_id != null) || var.mq_broker_encryption_options_kms_key_id == null
    error_message = "mq_broker_encryption_options_kms_key_id requires setting mq_broker_encryption_options_use_aws_owned_key to false."
  }
}

variable "mq_broker_encryption_options_use_aws_owned_key" {
  description = "Whether to enable an AWS-owned KMS CMK that is not in your account.Setting to false without configuring mq_broker_encryption_options_kms_key_id will create an AWS-managed CMK aliased to aws/mq in your account."
  type        = bool
  default     = true
}

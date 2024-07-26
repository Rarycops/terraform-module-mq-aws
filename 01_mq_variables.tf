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

variable "mq_broker_ldap_server_metadata_hosts" {
  description = "List of a fully qualified domain name of the LDAP server and an optional failover server.(Currently, AWS may not process changes to LDAP server metadata.)"
  type        = list(string)
  default     = null
  validation {
    condition     = (var.mq_broker_engine_type != "RabbitMQ" && var.mq_broker_ldap_server_metadata_hosts != null) || var.mq_broker_ldap_server_metadata_hosts == null
    error_message = "Not supported for engine_type RabbitMQ."
  }
}

variable "mq_broker_ldap_server_metadata_role_base" {
  description = "Fully qualified name of the directory to search for a user's groups.(Currently, AWS may not process changes to LDAP server metadata.)"
  type        = string
  default     = null
  validation {
    condition     = (var.mq_broker_engine_type != "RabbitMQ" && var.mq_broker_ldap_server_metadata_role_base != null) || var.mq_broker_ldap_server_metadata_role_base == null
    error_message = "Not supported for engine_type RabbitMQ."
  }
}

variable "mq_broker_ldap_server_metadata_role_name" {
  description = "Specifies the LDAP attribute that identifies the group name attribute in the object returned from the group membership query.(Currently, AWS may not process changes to LDAP server metadata.)"
  type        = string
  default     = null
  validation {
    condition     = (var.mq_broker_engine_type != "RabbitMQ" && var.mq_broker_ldap_server_metadata_role_name != null) || var.mq_broker_ldap_server_metadata_role_name == null
    error_message = "Not supported for engine_type RabbitMQ."
  }
}

variable "mq_broker_ldap_server_metadata_role_search_matching" {
  description = "Search criteria for groups.(Currently, AWS may not process changes to LDAP server metadata.)"
  type        = string
  default     = null
  validation {
    condition     = (var.mq_broker_engine_type != "RabbitMQ" && var.mq_broker_ldap_server_metadata_role_search_matching != null) || var.mq_broker_ldap_server_metadata_role_search_matching == null
    error_message = "Not supported for engine_type RabbitMQ."
  }
}

variable "mq_broker_ldap_server_metadata_role_search_subtree" {
  description = "Whether the directory search scope is the entire sub-tree.(Currently, AWS may not process changes to LDAP server metadata.)"
  type        = bool
  default     = false
  validation {
    condition     = (var.mq_broker_engine_type != "RabbitMQ" && var.mq_broker_ldap_server_metadata_role_search_subtree != false) || var.mq_broker_ldap_server_metadata_role_search_subtree == false
    error_message = "Not supported for engine_type RabbitMQ."
  }
}

variable "mq_broker_ldap_server_metadata_service_account_password" {
  description = "Service account password.(Currently, AWS may not process changes to LDAP server metadata.)"
  type        = string
  default     = null
  validation {
    condition     = (var.mq_broker_engine_type != "RabbitMQ" && var.mq_broker_ldap_server_metadata_service_account_password != null) || var.mq_broker_ldap_server_metadata_service_account_password == null
    error_message = "Not supported for engine_type RabbitMQ."
  }
}

variable "mq_broker_ldap_server_metadata_service_account_username" {
  description = "Service account username.(Currently, AWS may not process changes to LDAP server metadata.)"
  type        = string
  default     = null
  validation {
    condition     = (var.mq_broker_engine_type != "RabbitMQ" && var.mq_broker_ldap_server_metadata_service_account_username != null) || var.mq_broker_ldap_server_metadata_service_account_username == null
    error_message = "Not supported for engine_type RabbitMQ."
  }
}

variable "mq_broker_ldap_server_metadata_user_base" {
  description = "Fully qualified name of the directory where you want to search for users.(Currently, AWS may not process changes to LDAP server metadata.)"
  type        = string
  default     = null
  validation {
    condition     = (var.mq_broker_engine_type != "RabbitMQ" && var.mq_broker_ldap_server_metadata_user_base != null) || var.mq_broker_ldap_server_metadata_user_base == null
    error_message = "Not supported for engine_type RabbitMQ."
  }
}

variable "mq_broker_ldap_server_metadata_user_role_name" {
  description = "Specifies the name of the LDAP attribute for the user group membership.(Currently, AWS may not process changes to LDAP server metadata.)"
  type        = string
  default     = null
  validation {
    condition     = (var.mq_broker_engine_type != "RabbitMQ" && var.mq_broker_ldap_server_metadata_user_role_name != null) || var.mq_broker_ldap_server_metadata_user_role_name == null
    error_message = "Not supported for engine_type RabbitMQ."
  }
}

variable "mq_broker_ldap_server_metadata_user_search_matching" {
  description = "Search criteria for users.(Currently, AWS may not process changes to LDAP server metadata.)"
  type        = string
  default     = null
  validation {
    condition     = (var.mq_broker_engine_type != "RabbitMQ" && var.mq_broker_ldap_server_metadata_user_search_matching != null) || var.mq_broker_ldap_server_metadata_user_search_matching == null
    error_message = "Not supported for engine_type RabbitMQ."
  }
}


variable "mq_broker_ldap_server_metadata_user_search_subtree" {
  description = "Whether the directory search scope is the entire sub-tree.(Currently, AWS may not process changes to LDAP server metadata.)"
  type        = bool
  default     = false
  validation {
    condition     = (var.mq_broker_engine_type != "RabbitMQ" && var.mq_broker_ldap_server_metadata_user_search_subtree != false) || var.mq_broker_ldap_server_metadata_user_search_subtree == false
    error_message = "Not supported for engine_type RabbitMQ."
  }
}

variable "mq_broker_logs_audit" {
  description = "Enables audit logging. User management action made using JMX or the ActiveMQ Web Console is logged."
  type        = string
  default     = "false"
  validation {
    condition     = (var.mq_broker_engine_type != "ActiveMQ" && var.mq_broker_logs_audit != "false") || var.mq_broker_logs_audit == "false"
    error_message = "Auditing is only possible for engine_type of ActiveMQ."
  }
}

variable "mq_broker_logs_general" {
  description = "Enables general logging via CloudWatch."
  type        = bool
  default     = false
  validation {
    condition     = (var.mq_broker_engine_type != "ActiveMQ" && var.mq_broker_logs_general != false) || var.mq_broker_logs_general == false
    error_message = "Auditing is only possible for engine_type of ActiveMQ."
  }
}

variable "mq_broker_maintenance_window_start_time_day_of_week" {
  description = "Day of the week."
  type        = string
  default     = null
  validation {
    condition = can(
      regex(
        "^MONDAY|TUESDAY|WEDNESDAY|THURSDAY|FRIDAY|SATURDAY|SUNDAY$",
        var.mq_broker_maintenance_window_start_time_day_of_week
      )
    ) || var.mq_broker_maintenance_window_start_time_day_of_week == null
    error_message = "Only days of the week are allowed e.g., MONDAY, TUESDAY, or WEDNESDAY."
  }
}

variable "mq_broker_maintenance_window_start_time_time_of_day" {
  description = "Time, in 24-hour format."
  type        = string
  default     = null
  validation {
    condition = can(
      regex(
        "^(?:[01]\\d|2[0-3]):[0-5]\\d$",
        var.mq_broker_maintenance_window_start_time_time_of_day
      )
    ) || var.mq_broker_maintenance_window_start_time_time_of_day == null
    error_message = "The time must be in 24-hour format e.g., 02:00."
  }
}

variable "mq_broker_maintenance_window_start_time_time_zone" {
  description = "Time zone in either the Country/City format or the UTC offset format, e.g., CET."
  type        = string
  default     = null
}

variable "mq_broker_publicly_accessible" {
  description = "Whether to enable connections from applications outside of the VPC that hosts the broker's subnets."
  type        = bool
  default     = false
}

variable "mq_broker_security_groups" {
  description = "List of security group IDs assigned to the broker."
  type        = list(string)
  default     = null
}

variable "mq_broker_storage_type" {
  description = " Storage type of the broker."
  type        = string
  default     = null
  validation {
    condition = (
      can(
        regex(
          "^efs|ebs$",
          var.mq_broker_storage_type
        )
      ) && var.mq_broker_engine_type == "ActiveMQ"
    ) || (var.mq_broker_storage_type == "ebs" && var.mq_broker_engine_type == "RabbitMQ") || (var.mq_broker_storage_type == null)
    error_message = "For engine_type ActiveMQ, the valid values are efs and ebs, and the AWS-default is efs. For engine_type RabbitMQ, only ebs is supported. When using ebs, only the mq.m5 broker instance type family is supported."
  }
}

variable "mq_broker_subnet_ids" {
  description = "List of subnet IDs in which to launch the broker."
  type        = set(string)
  default     = null
  validation {
    condition = (
      var.mq_broker_subnet_ids != null && can(length(var.mq_broker_subnet_ids) == 1) && var.mq_broker_deployment_mode == "SINGLE_INSTANCE") || (
      var.mq_broker_subnet_ids != null && can(length(var.mq_broker_subnet_ids) > 1) && can(regex("^ACTIVE_STANDBY_MULTI_AZ|CLUSTER_MULTI_AZ$", var.mq_broker_deployment_mode))) || (
      var.mq_broker_subnet_ids == null
    )
    error_message = "A SINGLE_INSTANCE deployment requires one subnet. An ACTIVE_STANDBY_MULTI_AZ deployment requires multiple subnets."
  }
}

variable "mq_broker_tags" {
  description = "Tags provided for the broker"
  type        = map(string)
  default     = {}
}

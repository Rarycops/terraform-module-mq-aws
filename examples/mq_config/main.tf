module "mq_broker_activemq" {
  source = "../../"

  # MQ
  mq_broker_broker_name        = "test_activemq"
  mq_broker_engine_type        = "ActiveMQ"
  mq_broker_engine_resion      = "5.17.6"
  mq_broker_host_instance_type = "mq.t3.micro"
  mq_broker_user_map = {
    "user_1" = {
      console_access   = false
      groups           = ["users"]
      password         = "test123456789"
      replication_user = false
      username         = "test"
    }
    "user_2" = {
      console_access   = true
      groups           = null
      password         = "test123456789"
      replication_user = null
      username         = "test2"
    }
  }
  mq_broker_storage_type = "efs"

  # MQ CONFIG
  mq_configuration_data = <<DATA
    <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
    <broker xmlns="http://activemq.apache.org/schema/core">
      <plugins>
        <forcePersistencyModeBrokerPlugin persistenceFlag="true"/>
        <statisticsBrokerPlugin/>
        <timeStampingBrokerPlugin ttlCeiling="86400000" zeroExpirationOverride="86400000"/>
      </plugins>
    </broker>
    DATA
}

module "mq_broker_rabbitmq" {
  source = "../../"

  # MQ
  mq_broker_broker_name        = "test_rabbitmq"
  mq_broker_engine_type        = "RabbitMQ"
  mq_broker_engine_resion      = "5.17.6"
  mq_broker_host_instance_type = "mq.t3.micro"
  mq_broker_user_map = {
    "user_1" = {
      console_access   = false
      groups           = ["users"]
      password         = "test123456789"
      replication_user = false
      username         = "test"
    }
    "user_2" = {
      console_access   = true
      groups           = null
      password         = "test123456789"
      replication_user = null
      username         = "test2"
    }
  }
  mq_broker_storage_type = "ebs"
}

use Mix.Config

config :ex_kafka_logger,
  kafka_topic: "logging"

config :kafka_ex,
  brokers: [
    {"127.0.0.1", 9092}
  ],
  consumer_group: "consumer-group",
  sync_timeout: 3000,
  max_restarts: 10,
  max_seconds: 60,
  kafka_version: "0.9.0",
  use_ssl: false

use Mix.Config

config :kafka_ex,
  brokers: [{"127.0.0.1", 9092}],
  consumer_group: "camp-service",
  disable_default_worker: false,
  sync_timeout: 3000,
  max_restarts: 10,
  max_seconds: 60,
  kafka_version: "0.9.0",
  use_ssl: false

import_config "#{Mix.env}.exs"

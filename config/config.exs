use Mix.Config

config :kaffe,
  consumer: [
    heroku_kafka_env: false,
    endpoints: [kafka: 9092],
    topics: ["logging"],
    consumer_group: "logger",
    message_handler: KafkaMessageBus.Consumer,
    async_message_ack: false,
    offset_commit_interval_seconds: 10,
    start_with_earliest_message: false,
    rebalance_delay_ms: 100,
    max_bytes: 10_000,
    subscriber_retries: 5,
    subscriber_retry_delay_ms: 5,
    worker_allocation_strategy: :worker_per_topic_partition
    ],
  producer: [
    partition_strategy: :md5,
    endpoints: [kafka: 9092],
    topics: ["logging"]
  ],
  kafka_mod: :brod

import_config "#{Mix.env}.exs"

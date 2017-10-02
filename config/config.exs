use Mix.Config

config :kaffe,
  consumer: [],
  producer: [
    partition_strategy: :md5,
    endpoints: [kafka: 9092],
    topics: ["logging"]
  ],
  kafka_mod: :brod

import_config "#{Mix.env}.exs"

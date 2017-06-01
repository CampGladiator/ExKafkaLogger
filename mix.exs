defmodule ExKafkaLogger.Mixfile do
  use Mix.Project

  def project do
    [ app: :ex_kafka_logger,
      version: "0.1.0",
      elixir: "~> 1.4",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      name: "ExKafkaLogger",
      source_url: "https://github.com/jeffhsta/ExKafkaLogger"
    ]
  end

  def application do
    [applications: [:kafka_ex, :logger],
     mod: {ExKafkaLogger.Application, []}]
  end

  defp deps do
    [
      {:plug, "~> 1.3"},
      {:kafka_ex, "~> 0.6.5"},
      {:poison, "~> 3.1"},
    ]
  end

  defp description do
    """
    Elixir logger that serializes to JSON and publish it to Apache Kafka
    """
  end

  defp package do
    [
      maintainers: ["Jefferson Stachelski", "Gabriel Alves"],
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => "https://github.com/jeffhsta/ExKafkaLogger"}
    ]
  end
end

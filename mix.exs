defmodule ExKafkaLogger.Mixfile do
  use Mix.Project

  def project do
    [ app: :ex_kafka_logger,
      version: "2.0.0",
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
    [ applications: [:logger, :kafka_ex],
      mod: {ExKafkaLogger.Application, []}
    ]
  end

  defp deps do
    [
      {:poison, "~> 2.0"},
      {:kafka_ex, "~> 0.8"},
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end

  defp description do
    """
    Elixir logger that serializes to JSON and publish it to Apache Kafka
    """
  end

  defp package do
    [ maintainers: ["Jefferson Stachelski", "Gabriel Alves"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/jeffhsta/ExKafkaLogger"}
    ]
  end
end

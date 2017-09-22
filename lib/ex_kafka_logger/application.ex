defmodule ExKafkaLogger.Application do
  use Application
  @topic Application.get_env(:ex_kafka_logger, :kafka_topic)

  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    opts = [strategy: :one_for_one, name: ExKafkaLogger.Supervisor]
    Supervisor.start_link([], opts)
  end
end

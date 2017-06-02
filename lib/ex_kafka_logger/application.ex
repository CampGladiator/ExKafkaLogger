defmodule ExKafkaLogger.Application do
  use Application

  def start(_type, _args) do
    if is_nil(Application.get_env(:ex_kafka_logger, :kafka_topic)) do
      raise RuntimeError, message: "There is no topic configured"
    end
    import Supervisor.Spec, warn: false

    children = [
      worker(ExKafkaLogger.KafkaClient, [])
    ]

    opts = [strategy: :one_for_one, name: ExKafkaLogger.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

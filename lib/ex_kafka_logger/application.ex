defmodule ExKafkaLogger.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(ExKafkaLogger.KafkaClient, [])
    ]

    opts = [strategy: :one_for_one, name: ExKafkaLogger.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

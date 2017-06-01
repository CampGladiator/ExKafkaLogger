defmodule ExKafkaLogger.KafkaClient do
  use GenServer

  @topic Application.get_env(:ex_kafka_logger, :kafka_topic)
  @uris Application.get_env(:ex_kafka_logger, :kafka_uris)
  @consumer_group Application.get_env(:ex_kafka_logger, :kafka_consumer_group)

  # Server API

  def start_link() do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(_) do
    KafkaEx.create_worker(:no_name, [ uris: @uris, consumer_group: @consumer_group ])
  end

  def handle_call({:message, message}, _from, kafka_pid) do
    KafkaEx.produce(@topic, 0, message, worker_name: kafka_pid)
    {:reply, :ok, kafka}
  end

  # Public API

  def produce(message) do
    IO.inspect message, label: "Sending to GenServer KafkaClient"
    GenServer.call(__MODULE__, {:message, message})
  end
end

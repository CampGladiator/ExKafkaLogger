defmodule ExKafkaLogger.KafkaClient do
  use GenServer

  @topic Application.get_env(:ex_kafka_logger, :kafka_topic, "logging")

  # Server API

  def start_link() do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(_), do: {:ok, :ok}

  def handle_call({:message, message}, _from, state) do
    KafkaEx.produce(@topic, 0, message)
    {:reply, :ok, state}
  end

  def handle_call(_, _from, state), do: {:reply, :ok, state}

  # Public API

  def produce(message) do
    if not is_nil(GenServer.whereis(__MODULE__)) do
      GenServer.call(__MODULE__, {:message, message})
    end
    :ok
  end
end

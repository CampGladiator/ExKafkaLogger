defmodule ExKafkaLogger.KafkaClient do
  use GenServer
  alias Kaffe.Producer

  @topic Application.get_env(:ex_kafka_logger, :kafka_topic, "logging")

  def produce(message) do
    IO.puts "\nProduce Message ******"
    key = "#{0..9999 |> Enum.take_random(1) |> List.first}"
    Producer.produce_sync(@topic, [{key, message}])
    :ok
  end
end

defmodule ExKafkaLogger.KafkaClient do
  use GenServer

  @topic Application.get_env(:ex_kafka_logger, :kafka_topic, "logging")

  def produce(message), do: KafkaEx.produce(@topic, 0, message)
end

defmodule ExKafkaLogger.KafkaClient do
  use GenServer

  @topic Application.get_env(:ex_kafka_logger, :kafka_topic, "logging")

  def produce(message, key \\ nil) do
    partition = select_partition(key)
    IO.inspect(%{partition: partition, key: key}, label: "Produce message")
    KafkaEx.produce(@topic, partition, message, key: key)
  end

  defp select_partition(nil) do
    total_partitions = get_total_partitions() - 1
    Enum.random(0..total_partitions)
  end

  defp select_partition(msg_key) do
    :crypto.hash(:md5, msg_key)
    |> :binary.bin_to_list()
    |> Enum.sum()
    |> rem(get_total_partitions())
  end

  defp get_total_partitions do
    KafkaEx.metadata(topic: @topic)
    |> Map.get(:topic_metadatas)
    |> List.first()
    |> Map.get(:partition_metadatas)
    |> Enum.count()
  end
end

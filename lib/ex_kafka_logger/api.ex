defmodule ExKafkaLogger.API do
  @service_name Application.get_env(:ex_kafka_logger, :service_name)

  # def log(level, content}) when: is_bitstring(content) do
  #   # Handle log as a String
  #   parsed_log = %{} # parser logic
  #   log(Map.merge(content, %{log: parsed_log}))
  # end


  defmacro __using__(_) do
    quote do
      def log(level, content = %{timestamp: timestamp_str}) do
        IO.inspect content, label: "content"

        log = %{
          timestamp: timestamp_str,
          info: content,
          level: level |> Atom.to_string |> String.upcase,
          service: @service_name,
          tracker_id: "" # TODO: get this tracker_id from
        }
        |> Poison.encode!

        IO.inspect log, label: "Log serialized to JSON"
        ExKafkaLogger.KafkaClient.produce(log)
      end

      def log(level, content) when is_map(content) do
        IO.inspect content, label: "Content without a timestamp"

        new_content = content
          |> Map.merge(%{ timestamp: DateTime.utc_now |> DateTime.to_string })

        log(level, new_content)
      end
    end
  end
end

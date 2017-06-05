defmodule ExKafkaLogger.API do
  defmacro __using__(_) do
    quote do
      @service_name Application.get_env(:ex_kafka_logger, :service_name)
      @default_tracker_id "No-Tracker-ID"

      def log(level, content = %{timestamp: timestamp_str}) do
        log = %{
          timestamp: timestamp_str,
          info: content,
          level: level |> Atom.to_string |> String.upcase,
          service: @service_name,
          tracker_id: content.tracker_id
        }
        |> Poison.encode!

        ExKafkaLogger.KafkaClient.produce(log)
      end

      def log(level, content) when is_map(content) do
        new_content = content
          |> Map.merge(%{ timestamp: DateTime.utc_now |> DateTime.to_string })

        log(level, new_content)
      end

      def log(level, content) when is_bitstring(content) do
        log(level, %{log: content})
      end
    end
  end
end

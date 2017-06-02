defmodule ExKafkaLogger.EventListener do
  defmacro __using__(_) do
    quote do
      use GenEvent

      def init(state), do: {:ok, state}
      def handle_call(_, state), do: {:ok, :ok, state}

      def handle_event({level, _pid, {_logger, msg, timestamp, metadata}}, state) do
        {{year, month, day}, {hour, minute, second, ms}} = timestamp
        timestamp_str = "#{year}-#{month}-#{day}T#{hour}:#{minute}:#{second}.#{ms}Z"

        content = %{
          timestamp: timestamp_str,
          info: msg,
          metadata: convert_to_map(metadata) |> Map.delete(:pid)
        }

        log(level, content)
        {:ok, state}
      end

      defp convert_to_map(metadata) do
        Enum.reduce(metadata, %{},
          fn {key, value}, acc ->
            Map.put(acc, key, value)
          end)
      end
    end
  end
end

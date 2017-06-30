defmodule ExKafkaLogger.EventListener do
  defmacro __using__(_) do
    quote do
      @default_tracker_id "No-Tracker-ID"
      use GenEvent

      def init(state), do: {:ok, state}

      def handle_event({level, _pid, {_logger, msg, _timestamp, metadata}}, state) do
        try do
          metadata_map = Map.new metadata

          content = %{
            type: "INTERNAL",
            info: msg,
            tracker_id: Map.get(metadata_map, :request_id, @default_tracker_id),
            metadata: Map.delete(metadata_map, :pid)
          }

          log(level, content)
          {:ok, state}
        rescue
          _ -> {:error,  "Some error happened when parsing the log"}
        end
      end

      def handle_call(_, state), do: {:ok, :ok, state}
    end
  end
end

defmodule ExKafkaLogger.EventListener do
  defmacro __using__(_) do
    quote do
      @default_tracker_id "No-Tracker-ID"
      use GenEvent

      def init(state), do: {:ok, state}

      def handle_event({level, _pid, {_logger, msg, _timestamp, metadata}}, state) do
        try do
          metadata_map = Map.new(metadata)

          content = %{
            type: "INTERNAL",
            data: convert_message(msg),
            tracker_id: Map.get(metadata_map, :request_id, @default_tracker_id),
            metadata: Map.delete(metadata_map, :pid)
          }

          log(level, content)
          {:ok, state}
        rescue
          _ ->
            {:error,  "Some error happened when parsing the log"}
            {:ok, state}
        end
      end

      def handle_call(_, state), do: {:ok, :ok, state}

      defp convert_message(msg) when is_list(msg) do
        msg |> List.flatten |> Enum.map(&convert_int_asc_to_string/1) |> Enum.join("")
      end
      defp convert_message(msg), do: msg

      defp convert_int_asc_to_string(data) when is_bitstring(data), do: data
      defp convert_int_asc_to_string(data) when is_integer(data), do: <<data>>
    end
  end
end

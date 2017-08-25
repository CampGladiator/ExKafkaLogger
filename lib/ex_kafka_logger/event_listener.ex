defmodule ExKafkaLogger.EventListener do
  defmacro __using__(_) do
    quote do
      use GenEvent

      def init(state), do: {:ok, state}

      def handle_event({level, _pid, {_logger, log_msg, _timestamp, metadata}}, state) do
        try do
          metadata_map = Map.new(metadata)

          content = %{
            level: level,
            metadata: Map.delete(metadata_map, :pid),
            content: convert_message(log_msg),
            type: convert_log_type(metadata_map.module)
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

      defp convert_log_type(module) do
        "Elixir." <> module_name = module |> Atom.to_string
        module_name
        |> String.split(".")
        |> List.first
      end
    end
  end
end

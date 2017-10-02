defmodule ExKafkaLogger.EventListener do
  defmacro __using__(_) do
    quote do
      @behaviour :gen_event
      alias ExKafkaLogger.ParseHandler

      def init(state), do: {:ok, state}

      def handle_event({level, _pid, {_logger, log_msg, _timestamp, metadata}}, state) do
        try do
          metadata
          |> Map.new()
          |> Map.delete(:pid)
          |> process_log(log_msg, level)
          {:ok, state}
        rescue
          _ -> {:ok, state}
        end
      end

      def handle_call(_, state), do: {:ok, state}
      def handle_info(_, state), do: {:ok, state}

      defp process_log(%{application: :kaffe}, _log_msg, _level), do: :ok
      defp process_log(metadata, log_msg, level) do
        content = %{
          level: level,
          metadata: metadata,
          content: convert_message(log_msg),
          type: convert_log_type(metadata.module)
        }

        ParseHandler.log(level, content)
      end

      defp convert_message(msg) when is_list(msg) do
        msg
        |> List.flatten
        |> Enum.map(&convert_int_asc_to_string/1)
        |> Enum.join("")
      end
      defp convert_message(msg) do
        msg
        |> Poison.decode()
        |> case do
          {:ok, decoded} -> decoded
          _ -> msg
        end
      end

      defp convert_int_asc_to_string(data) when is_bitstring(data), do: data
      defp convert_int_asc_to_string(data) when is_integer(data), do: <<data>>

      defp convert_log_type(nil), do: nil
      defp convert_log_type(module) do
        "Elixir." <> module_name = module |> Atom.to_string
        module_name
        |> String.split(".")
        |> List.first
      end
    end
  end
end

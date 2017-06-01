defmodule ExKafkaLogger do
  use GenEvent
  use ExKafkaLogger.API

  # require Logger

  def init(state), do: {:ok, state}
  def handle_call(_, state), do: {:ok, :ok, state}

  def handle_event({level, _pid, {_logger, msg, timestamp, metadata}}, state) do
    IO.puts "Log a log from Logger"

    {{year, month, day}, {hour, minute, second, ms}} = timestamp
    timestamp_str = "#{year}-#{month}-#{day}T#{hour}:#{minute}:#{second}.#{ms}Z"

    content = %{
      timestamp: timestamp_str,
      info: msg,
      metadata: metadata
    }

    IO.inspect content, label: "About to call ExKafkaLogger's log"

    log(level, content)
    {:ok, state}
  end
end

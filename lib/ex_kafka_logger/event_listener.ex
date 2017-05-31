defmodule ExKafkaLogger.EventListener do
  use GenEvent
  require Logger

  def init(state), do: {:ok, state}
  def handle_call(_, state), do: {:ok, :ok, state}

  def handle_event({level, _pid, {_logger, msg, timestamp, metadata}}, state) do
    {{year, month, day}, {hour, minute, second, ms}} = timestamp
    timestamp_str = "#{year}-#{month}-#{day}T#{hour}:#{minute}:#{second}.#{ms}Z"

    content = %{
      timestamp: timestamp_str,
      info: msg,
      metadata: metadata
    }

    log(level, content)
    {:ok, state}
  end
end

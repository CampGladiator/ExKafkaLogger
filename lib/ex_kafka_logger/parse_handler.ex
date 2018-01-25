defmodule ExKafkaLogger.ParseHandler do
  @service_name Application.get_env(:ex_kafka_logger, :service_name)

  alias ExKafkaLogger.KafkaClient

  @doc """
  The function receive two arguments the log level that is an `Atom` and
  could be (`:info`, `:debug`, `:warn` or `:error`), the second argument is
  the log that is a `Map`
  ## Example
  ```elixir
  iex> ExKafkaLogger.log(:info, %{timestamp: "2017-06-05T16:13:30.000Z", log: "Some info to log on Kafka"}, metadata: %{})
  :ok
  ```
  """
  def log(level, data = %{timestamp: timestamp, content: content}) do
    %{
      timestamp: timestamp,
      metadata: data |> Map.get(:metadata, %{}),
      level: level |> Atom.to_string() |> String.upcase(),
      service: @service_name,
      request_id: data |> Map.get(:request_id),
      content: content
    }
    |> Poison.encode!()
    |> KafkaClient.produce()
  end

  @doc """
  The function receive two arguments the log level that is an `Atom` and
  could be (`:info`, `:debug`, `:warn` or `:error`), the second argument is
  the log that is a `Map`

  It's an alias to `ExKafkaLogger.API.log/2` that receives a log as a `Map`
  with a `timestamp`
  ## Example
  ```elixir
  iex> ExKafkaLogger.log(:info, %{track_id: 123, log: "Some info to log on Kafka"}, metadata: %{})
  :ok
  ```
  """
  def log(level, log) when is_map(log) do
    log(level, Map.put(log, :timestamp, DateTime.utc_now()))
  end

  @doc """
  The function receive two arguments the log level that is an `Atom` and
  could be (`:info`, `:debug`, `:warn` or `:error`), the second argument is
  the log that is a `String`
  ## Example
  ```elixir
  iex> ExKafkaLogger.log(:info, "Some info to log on Kafka")
  :ok
  ```
  """
  def log(level, content) when is_bitstring(content) do
    log(level, %{content: content})
  end
end

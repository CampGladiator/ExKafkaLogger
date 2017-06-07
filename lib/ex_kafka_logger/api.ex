defmodule ExKafkaLogger.API do
  defmacro __using__(_) do
    quote do
      @service_name Application.get_env(:ex_kafka_logger, :service_name)
      @default_tracker_id "No-Tracker-ID"

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
      def log(level, content) when is_map(content) do
        new_content = Map.merge(content, %{ timestamp: get_timestamp_str() })
        log(level, new_content)
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
        log(level, %{log: content})
      end

      defp get_timestamp_str() do
        DateTime.utc_now()
        |> DateTime.to_iso8601()
      end
    end
  end
end

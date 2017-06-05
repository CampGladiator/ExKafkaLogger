defmodule ExKafkaLogger do
  @moduledoc File.read!(Path.expand("../README.md", __DIR__))

  use ExKafkaLogger.API
  use ExKafkaLogger.EventListener

  @doc """
  Alias to `ExKafkaLogger.log(:info, log)`
  The argument could be a `String` or a `Map`
  ## Example
  ```elixir
  iex> ExKafkaLogger.info("Some info to log on Kafka")
  :ok
  ```
  """
  def info(log), do: log(:info, log)

  @doc """
  Alias to `ExKafkaLogger.log(:error, log)`
  The argument could be a `String` or a `Map`
  ## Example
  ```elixir
  iex> ExKafkaLogger.error("Some error to log on Kafka")
  :ok
  ```
  """
  def error(log), do: log(:error, log)

  @doc """
  Alias to `ExKafkaLogger.log(:debug, log)`
  The argument could be a `String` or a `Map`
  ## Example
  ```elixir
  iex> ExKafkaLogger.debug("Something to debug and log on Kafka")
  :ok
  ```
  """
  def debug(log), do: log(:debug, log)

  @doc """
  Alias to `ExKafkaLogger.log(:warn, log)`
  The argument could be a `String` or a `Map`
  ## Example
  ```elixir
  iex> ExKafkaLogger.warn("Some warn to log on Kafka")
  :ok
  ```
  """
  def warn(log), do: log(:warn, log)
end

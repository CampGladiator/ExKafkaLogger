defmodule ExKafkaLogger do
  use ExKafkaLogger.API
  use ExKafkaLogger.EventListener

  def info(log), do: log(:info, log)
  def error(log), do: log(:error, log)
  def debug(log), do: log(:debug, log)
  def warn(log), do: log(:warn, log)
end

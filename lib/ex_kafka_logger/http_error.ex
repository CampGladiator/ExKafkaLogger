defmodule ExKafkaLogger.HttpError do
  def template(401) do
    response_template("Unathorized")
  end

  def template(404) do
    response_template("Not found")
  end

  def template(422) do
    response_template("Unprocessable entity")
  end

  def template(500) do
    response_template("Internal server error")
  end

  def template(_) do
    response_template("unknown error")
  end

  defp meta_template(message) do
    %{ message: message }
  end
end

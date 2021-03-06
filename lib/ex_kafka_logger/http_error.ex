defmodule ExKafkaLogger.HttpError do
  def template(401) do
    meta_template("Unathorized")
  end

  def template(404) do
    meta_template("Not found")
  end

  def template(422) do
    meta_template("Unprocessable entity")
  end

  def template(500) do
    meta_template("Internal server error")
  end

  def template(_) do
    meta_template("unknown error")
  end

  defp meta_template(message) do
    %{message: message}
  end
end

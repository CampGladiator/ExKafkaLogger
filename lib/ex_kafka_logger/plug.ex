defmodule ExKafkaLogger.Plug do
  import Plug.Conn

  @track_id_key "x-request-id"
  @service_name Application.get_env(:ex_kafka_logger, :service_name)

  def init(default), do: default

  def call(conn, _opts) do
    register_before_send(conn, &handle_log/1)
  end

  defp handle_log(conn) do
    {@track_id_key, tracker_id} = conn.resp_headers
      |> Enum.filter(fn({k, _v}) -> k == @track_id_key end)
      |> List.first

    content = %{
      service: @service_name,
      level: :info,
      tracker_id: tracker_id,
      info: %{
        body_params: conn.body_params,
        cookies: conn.cookies,
        host: conn.host,
        method: conn.method,
        path_info: conn.path_info,
        path_params: conn.path_params,
        query_params: conn.query_params,
        remote_ip: "{127.0.0.1}", # TODO: conn.remote_ip = {127, 0. 0, 1},
        req_cookies: conn.req_cookies,
        req_headers: "HTTP headers", # TODO: conn.req_headers = %{ {}, {} },
        request_path: conn.request_path,
        resp_body: conn.resp_body,
        resp_cookies: conn.resp_cookies,
        resp_headers: "HTTP headers", # TODO: conn.resp_headers = %{ {}, {} },
        scheme: conn.scheme,
        script_name: conn.script_name,
        state: conn.state
      }
    }
    
    conn
  end
end

defmodule ExKafkaLogger.Plug do
  import Plug.Conn

  @track_id_key "x-request-id"
  @service_name Application.get_env(:ex_kafka_logger, :service_name)

  def init(default), do: default

  def call(conn, _opts) do
    register_before_send(conn, &handle_log/1)
  end

  defp handle_log(conn) do
    content = %{
      type: "NETWORK",
      service: @service_name,
      level: "INFO",
      tracker_id: extract_request_id(conn.resp_headers),
      data: %{
        path_info: conn.path_info,
        method: conn.method,
        body_params: conn.body_params,
        remote_ip: parse_remote_ip(conn.remote_ip),
        host: conn.host,

        cookies: conn.cookies,
        path_params: conn.path_params,
        query_params: conn.query_params,

        request_path: conn.request_path,
        req_cookies: conn.req_cookies,
        req_headers: Map.new(conn.req_headers),

        resp_headers: Map.new(conn.resp_headers),
        resp_body: Poison.decode!(conn.resp_body),
        resp_cookies: conn.resp_cookies,

        scheme: conn.scheme,
        script_name: conn.script_name,
        state: conn.state
      }
    }

    ExKafkaLogger.info(content)
    conn
  end

  defp parse_remote_ip(remote_ip) do
    remote_ip
    |> Tuple.to_list
    |> Enum.join(".")
  end

  defp extract_request_id(resp_headers) do
    {@track_id_key, tracker_id} = resp_headers
      |> Enum.filter(fn({k, _v}) -> k == @track_id_key end)
      |> List.first
    tracker_id
  end
end

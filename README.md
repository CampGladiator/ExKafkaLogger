# ExKafkaLogger

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `ex_kafka_logger` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:ex_kafka_logger, "~> 0.1.0"}]
end
```

### Configuration in 3 steps

#### Step 1

Add the ExKafkaLogger Plug on your Phoenix `endpoint.ex` file just above `plug YourApp.Router`

It should looks like:

```elixir
# ...

  plug Plug.Session,
    store: :cookie,
    key: "_my_app_key",
    signing_salt: "SECRET_SALT"

  plug ExKafkaLogger.Plug
  plug MyApp.Router
end
```

#### Step 2

Create a `handle_error` function in the end of your `router.ex` file to catch the
 errors without let Phoenix send the default errors response, like the example below.

```elixir
defp handle_errors(conn, _) do
  response = ExKafkaLogger.HttpError.template(conn.status)
  json(conn, response)
end
```

#### Step 3

Configure your application to make the Elixir `Logger` to use `ExKafkaLogger` as
one of your backend and let `ExKafkaLogger` knows how to connect in your Kafka
instance.

In your `config/ENV.exs` file add the lines like the example below.

```elixir
config :ex_kafka_logger,
  kafka_topic: "logging",
  kafka_uris: [
    {"127.0.0.1", 9092}
  ],
  kafka_consumer_group: “your_consumer_group”,
  service_name: “your_app_name”
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/ex_kafka_logger](https://hexdocs.pm/ex_kafka_logger).

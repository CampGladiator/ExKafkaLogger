# ExKafkaLogger

`ExKafkaLogger` is a Elixir library that works using [Poison](https://github.com/devinus/poison "Poison Library Github"), [KafkaEx](https://github.com/kafkaex/kafka_ex "KafkaEx library Github") and [Plug](https://github.com/elixir-lang/plug "Elixir Plug library Github") to log data, parse to JSON and send it to Kafka.

This library automatically gets data from the default Elixir `Logger` and from
every request/response from your project. This data (and any data you might
want to send) is then parsed and sent to Kafka with a specified topic.

Documentation is avaiable online at [https://hexdocs.pm/ex_kafka_logger](https://hexdocs.pm/ex_kafka_logger).


## Installation

The package can be installed by adding `ex_kafka_logger` to your list of
dependencies in `mix.exs`:

```elixir
def deps do
  [{:ex_kafka_logger, "~> 0.1"}]
end
```

After installing the library you will need to run the following command
```bash
$ mix deps.get
```

Then you will also need to follow the subsequent configuration steps.

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

Use `Plug.ErrorHandler` and create a `handle_error` function in the end of your `router.ex` file to catch the
 errors without let Phoenix send the default errors response, like the example below.

```elixir
use YourApp.Web, :router
use Plug.ErrorHandler

# ... your code ...

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
config :logger, backends: [:console, ExKafkaLogger]

config :ex_kafka_logger,
  kafka_topic: "your_logging_topic",
  service_name: "your_app_name"

 config :kafka_ex,
  brokers: [
    {"127.0.0.1", 9092},
  ],
  consumer_group: "consumer-group",
  disable_default_worker: false,
  sync_timeout: 3000,
  max_restarts: 10,
  max_seconds: 60,
  kafka_version: "0.9.0"
```

## Example Application

[Here](https://github.com/goalves/phoenixLoggedApp) is an example of how to use
this library to log a simple Phoenix Application.

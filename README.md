# ExKafkaLogger

`ExKafkaLogger` is a Elixir library that wraps `Elixir.Logger` in order to send all related logs to Kafka. It works using [Poison](https://github.com/devinus/poison "Poison Library Github") and [Kaffe](https://github.com/spreedly/kaffe/ "Kaffe library Github").

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

## Configuration

Configure your application to make the Elixir `Logger` to use `ExKafkaLogger` as
one of your backend and let `ExKafkaLogger` knows how to connect in your Kafka
instance.

In your `config/ENV.exs` file add the lines like the example below.

```elixir
config :logger, backends: [:console, ExKafkaLogger]

config :ex_kafka_logger,
  kafka_topic: "your_logging_topic",
  service_name: "your_app_name"

config :kaffe,
  consumer: [
    heroku_kafka_env: true,
    topics: ["interesting-topic"],
    consumer_group: "your-app-consumer-group",
    message_handler: MessageProcessor
  ]
```

## Example Application

[Here](https://github.com/goalves/phoenixLoggedApp) is an example of how to use
this library to log a simple Phoenix Application.

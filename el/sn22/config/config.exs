# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

# Configures the endpoint
config :sn22, Sn22Web.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: Sn22Web.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Sn22.PubSub,
  live_view: [signing_salt: "mo310+2N"]

config :sn22, smtp_opts: [[port: 2525]]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.

# config :sn22, Sn22.Mailer, adapter: Swoosh.Adapters.Local
config :sn22, Sn22.Mailer,
  adapter: Swoosh.Adapters.Sendgrid,
  api_key: "SG.x.x"

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.14.29",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017
      --outdir=../priv/static/assets --external:/fonts/* --external:/godot/*
       --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"

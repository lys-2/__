import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :sn22, Sn22Web.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "pv+kSY4QeGaxLfBfcW5WiiNum6O7BLcil4WQFfQJFlC2rKhw4vFFfk40IHdOlEz9",
  server: false

# In test we don't send emails.
config :sn22, Sn22.Mailer,
  adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

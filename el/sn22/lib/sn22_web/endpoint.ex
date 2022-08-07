defmodule Sn22Web.Endpoint do
  use Phoenix.Endpoint, otp_app: :sn22

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  @session_options [
    store: :cookie,
    key: "_sn22_key",
    signing_salt: "eT8p8zs4"
  ]

  socket "/socket", Sn22Web.UserSocket,
  websocket: [compress: true],
  longpoll: false

  socket "/live", Phoenix.LiveView.Socket,
   websocket: [connect_info: [session: @session_options]]

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phx.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/",
    from: :sn22,
    gzip: true,
    only: ~w(assets fonts images js
    1.js 1.pck 1.wasm 1.wasm.gz 1.audio.worklet.js
     favicon.ico robots.txt 1.png)

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
  end

  plug Phoenix.LiveDashboard.RequestLogger,
    param_key: "request_logger",
    cookie_key: "request_logger"

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session_options
  plug Sn22Web.Router
end

defmodule Sn22.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application




  @impl true
  def start(_type, _args) do

    IO.inspect System.cmd("whoami", [])
    IO.inspect System.cmd("ls", ["-la"])

    spawn(Sn22, :run, []) |> Process.register(:mb)
    spawn(Sn22, :run2, [1, {[], 0, 0}])
    spawn(M1, :init, []) |> Process.register(:main)

    children = [
      # Start the Telemetry supervisor
      M2,
      M3,
      Sn22Web.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Sn22.PubSub},
      # Start the Endpoint (http/https)
      Sn22Web.Endpoint,
      Sn22Web.Presence
      # Start a worker by calling: Sn22.Worker.start_link(arg)
      # {Sn22.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Sn22.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    Sn22Web.Endpoint.config_change(changed, removed)
    :ok
  end
end

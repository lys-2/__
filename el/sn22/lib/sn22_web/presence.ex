defmodule Sn22Web.Presence do
  use Phoenix.Presence, otp_app: :Sn22, pubsub_server: Sn22.PubSub
end

defmodule Sn22Web.Presence do
  use Phoenix.Presence, otp_app: :tutorial, pubsub_server: Sn22.PubSub
end

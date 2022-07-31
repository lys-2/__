defmodule Sn22Web.RoomChannel do
  use Phoenix.Channel

  def join("room:lobby", _message, socket) do
    IO.puts 1;
    {:ok, socket}
  end

  def join("room:" <> _private_room_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end
end

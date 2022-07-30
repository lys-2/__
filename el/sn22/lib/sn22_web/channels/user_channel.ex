defmodule Sn22Web.UserChannel do
  use Sn22Web, :channel
  alias Sn22Web.Presence

  @impl true
  def join("room:lobby", %{"name" => name}, socket) do
    inspect socket;
    send(self(), :after_join)
    {:ok, assign(socket, :name, name)}
  end

  def join("room:lobby", %{}, socket) do
    inspect socket;

    {:ok, socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  @impl true
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (user:lobby).
  @impl true
  def handle_in("shout", payload, socket) do
    broadcast(socket, "shout", payload)
    {:noreply, socket}
  end

  def handle_info(:after_join, socket) do
    {:ok, _} =
      Presence.track(socket, socket.assigns.name, %{
        online_at: inspect(System.system_time(:second))
      })

    push(socket, "presence_state", Presence.list(socket))
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  def handle_in("new_msg", %{"body" => body}, socket) do
    broadcast!(socket, "new_msg", %{body: body})
    {:noreply, socket}
  end

  defp authorized?(_payload) do
    true
  end
end


defmodule Sn22Web.Wgt1 do
  alias Sn22Web.Presence
  use Sn22Web, :live_view
  alias Phoenix.Socket.Broadcast

  def mount(p, %{"user" => user}, socket) do
    if connected?(socket), do:
    :timer.send_interval(12, :update)
    Phoenix.PubSub.subscribe(Sn22.PubSub, "wg")

    updated =
      socket
      |> assign(:msg, M4a.get2("sunraylmtd").twmsgr )

    {:ok, updated}
  end

  def handle_info(:update, socket) do

    {:noreply, socket
    |> assign(:msg, M4a.get2("sunraylmtd").twmsgr |> Enum.take 3)

  }
  end

  def render(assigns) do
    ~H"""

<%= for m <- @msg do %>
  <div class="name"><%=  m.sender<>": "<>m.msg %></div>

<% end %>

    """
  end
end

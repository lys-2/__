
defmodule Sn22Web.Ac do
  alias Sn22Web.Presence
  use Sn22Web, :live_view
  alias Phoenix.Socket.Broadcast

  def mount(p, %{"user" => user}, socket) do
    if connected?(socket), do:

    Phoenix.PubSub.subscribe(Sn22.PubSub, "ac")
    {:ok, u} = M7state.get_user(user);
    :timer.send_interval(25, {:update, u})

    updated =
      socket
      |> assign(:acc, M7state.get.inc.ymn)
      |> assign(:ex, u.ex)
      |> assign(:us, M7state.get.users)
      |> assign(:b, M7state.get.b)
      |> assign(:c, M7state.get.c)
      |> assign(:chips, M7state.get.chips)
      |> assign(:ua, u.a)
      |> assign(:ub, u.b)

    {:ok, updated}
  end

  def handle_info({:update, u}, socket) do

    {:noreply, socket
    |> assign(:acc, M7state.get.inc.ymn)
    |> assign(:chips, M7state.get.chips)

    |> assign(:b, M7state.get.b)
    |> assign(:us, M7state.get.users)
    |> assign(:c, M7state.get.c)
    |> assign(:ex, u.ex)


  }
  end

  def render(assigns) do
    ~H"""
        <%= (inspect @c)%>
<br>
    <%= (inspect @b) <>" p"%>

    <br>

<%= for {k,v} <- @ex do %>
  <span class="name"><%= "#{k}, #{v}__" %></span>
<% end %>

<br>

<%= for {k,v} <- @us do %>
  <span class="name"><%= "#{v.id}, #{v.a}, #{v.b}__" %></span>
<% end %>

  <%= for m <- @acc do %>
  <div class="name"><%= inspect m %></div>
<% end %>
<br>
    <%= (inspect @chips) <>""%>
    """
  end
end

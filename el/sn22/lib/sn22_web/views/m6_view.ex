defmodule Sn22Web.ThermostatLive do
alias Sn22Web.Presence
  use Sn22Web, :live_view


  @cursorview "cursorview"
  def mount(_params, _, socket) do
    n = Faker.Pokemon.name
    s = M6.get
    Sn22Web.Endpoint.subscribe(@cursorview)
    Presence.track(self(), @cursorview, socket.id, %{
      socket_id: socket.id,
      x: 50,
      y: 50,
      p: 50,
      name: n,
      # cl: M7.parse,
      mu: :erlang.memory(:total)
    })

    initial_users =
      Presence.list(@cursorview)
      |> Enum.map(fn {_, data} -> data[:metas] |> List.first() end)

    updated =
      socket
      |> assign(:user, n)
      |> assign(:users, initial_users)
      |> assign(:x, 50)
      |> assign(:y, 50)
      |> assign(:p, 50)
      |> assign(:cl, M7.parse)
      |> assign(c: Presence.list(@cursorview) |> map_size)
      |> assign(s: s)
      |> assign(mu: :erlang.memory(:total))
      |> assign(pc: :erlang.system_info(:process_count))
      |> assign(us:  '')

    {:ok, updated}
  end

  def terminate(_, socket) do
    # IO.inspect socket

  end


  def handle_event("cursor-move", %{"x" => x, "y" => y, "p" => p}, socket) do
    key = socket.id
    payload = %{x: x, y: y, p: p}
    IO.puts("#{floor x/16} #{floor y/16} #{p} #{inspect socket.assigns.user}");

    # IO.inspect socket

    metas =
      Presence.get_by_key(@cursorview, key)[:metas]
      |> List.first()
      |> Map.merge(payload)
      # |> assign(s: M6.get)


    Presence.update(self(), @cursorview, key, metas)

    # IO.inspect socket

    {:noreply, socket}
  end

  def handle_info(%{event: "presence_diff", payload: _payload}, socket) do
    users =
      Presence.list(@cursorview)
      |> Enum.map(fn {_, data} -> data[:metas] |> List.first() end)

    updated =
      socket
      |> assign(users: users)
      |> assign(socket_id: socket.id)
      |> assign(s: M6.get)
      |> assign(mu: :erlang.memory(:total))
      |> assign(pc: :erlang.system_info(:process_count))
      |> assign(c: Presence.list(@cursorview) |> map_size)

    {:noreply, updated}
  end



  def render(assigns) do
    ~H"""


    <%= for e <- @cl do %>
    <pre style={"
    position: absolute;
     top: "<>"#{e.y*16}"<>"px;
     left: "<>"#{e.x*16}"<>"px;
     filter: hue-rotate("<>"#{e.hue}"<>"deg);
     "}><%=
      "#{e.type}"
        %></pre>
    <% end %>


<span style="font-size: 24px;"> <%=

  @us

   %> </span>
<span style="font-size: 24px;"> <%= @c %> </span>
<span style="font-size: 24px;"> <%= @mu %> </span>
<span style="font-size: 24px;"> <%= @pc %> </span>

    <%= for user <- @users do %>
    <span style={"font-family:monospace;
    display: inline-block;
    position: absolute; top: "<>"#{user.y}"<>"px;
     left: "<>"#{user.x}"<>"px; "<>
    "filter: hue-rotate("<>"#{111}"<>"deg);
    font-size: "
      <>
    "#{32}"
    <>"px;
    transform: scale("
      <>
    "#{1}"
    <>", 1) rotate("<>
    "#{20}"
    <>"deg);

   filter: contrast(70%)
    hue-rotate( "
      <>
    "#{}"
    <>"deg)
    opacity(70%);
    "

    }><%=  "🦎" <> List.to_string(@s)  %>
   <span id="cursors" phx-hook="TrackClientCursor"
   style="  position: absolute; font-family:monospace;  background-color: deeppink;"> <%= user.name %></span>
    </span>
    <% end %>

    """
  end
end

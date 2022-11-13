defmodule Sn22Web.Store do
  alias Sn22Web.Presence

  use Sn22Web, :live_view

  def mount(_params, %{"user" => user}, socket) do
    if connected?(socket), do: Process.send_after(self(), :update, 1)

  {:ok, u} = M7state.get_user(user)

    updated =
      socket
      |> assign(:user, u.name)
      |> assign(:id, u.id)
      |> assign(:users, M7state.get.users)
      |> assign(:token, Phoenix.Controller.get_csrf_token())
      |> assign(:y, M8.t)
      # |> assign(:x, session)
    {:ok, updated}
  end

  def handle_info(:update, socket) do
    Process.send_after(self(), :update, 2000)
    {:noreply, assign(socket, :y, M8.t)
    |> assign(:users, M7state.get.users)
  }
  end

  def render(assigns) do
    ~H"""

<span style="
 font-size: 20px;
    color: yellow;
    "> Logged as <%= @id %>::<%= @user %></span>


<a href="/">aaaaaa</a>
<form action="/reg" method="POST" >

    <input type="hidden" value={"#{@token}"} name="_csrf_token"/>
    <input type="text" size="8" name="name" id="name" placeholder="...name"  maxlength="99">
    <input type="text" size="8" name="pw" id="pw" placeholder="...pw"  maxlength="99">
    <button>Рег</button>


</form>

<form action="/log" method="POST" >

    <input type="hidden" value={"#{@token}"} name="_csrf_token"/>
    <input type="text" size="8" name="id" id="id" placeholder="...id"  maxlength="99">
    <input type="text" size="8" name="key" id="pw" placeholder="...key"  maxlength="99">
    <button>Вход</button>
</form>

<form action="/logout" method="POST" >
<input type="hidden" value={"#{@token}"} name="_csrf_token"/>

    <button  name="log" value="out">Выхд</button>

</form>

<%= for {k, v} <- @users do %>
    <span style={"

    font-size: 16px;

     "}><%=
      v.id
        %></span>
        <span style={"

    font-size: 20px;
    color: yellow;

     "}><%=
      v.name
        %></span>
    <% end %>

    <span id="cursors" phx-hook="TrackClientCursor"
   style=" position: absolute;
   font-family:monospace;  background-color:
    deeppink;"> <%= 1 %>
    </span>
<pre style="
user-select: none;
pointer-events: none;
position: absolute; top: 132px;
font-family:monospace;
color: white;
  line-height: 4px;
  font-size: 8px;
  "><%= @y %></pre>


<script>


</script>

    """



  end
end

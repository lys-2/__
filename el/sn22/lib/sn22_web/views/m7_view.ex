defmodule Sn22Web.Store do

  use Sn22Web, :live_view

  def mount(_params, session, socket) do
    if connected?(socket), do:
   Process.send_after(self(), :update, 1)

    updated =
      socket
      |> assign(:user, M7state.get.users.u2.name<>"::2")
      |> assign(:users, M7state.get.users)
      |> assign(:token, Phoenix.Controller.get_csrf_token())
      |> assign(:y, M8.t)
      |> assign(:x, session)
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

<%= inspect @x %>

<a href="an@/st">aaaaaa</a>
<form action="/reg" method="POST" >

    <input type="hidden" value={"#{@token}"} name="_csrf_token"/>
    <input type="text" size="8" name="name" id="name" placeholder="...name"  maxlength="99">
    <input type="text" size="8" name="key" id="key" placeholder="...key"  maxlength="99">
    <button>Отпр</button>
    <button name="action">Отпр</button>
    <button name="action">Отпр</button>
    <input type="submit" name="action" value="Update" />

</form>


<%= for {k, v} <- @users do %>
    <span style={"

    font-size: 16px;

     "}><%=
      k
        %></span>
        <span style={"

    font-size: 20px;
    color: yellow;

     "}><%=
      v.name
        %></span>
    <% end %>


<pre style="
user-select: none;
pointer-events: none;
position: absolute; top: 132px;
font-family:monospace;
color: darkorange;
  line-height: 4px;
  font-size: 8px;
  "><%= @y %></pre>

      <script>

      </script>

    """
  end
end

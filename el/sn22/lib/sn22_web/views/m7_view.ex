defmodule Sn22Web.Store do
  alias Sn22Web.Presence

  use Sn22Web, :live_view

  def mount(p, %{"user" => user}, socket) do
    if connected?(socket), do: Process.send_after(self(), :update, 1)

  {:ok, u} = M7state.get_user(user)

    updated =
      socket
      |> assign(:user, u.name)
      |> assign(:uid, u.id)
      |> assign(:name, "")
      |> assign(:pw, "")
      |> assign(:id, "")
      |> assign(:key, "")
      |> assign(:info, u.info)
      |> assign(:changeset, :aaa)
      |> assign(:color, u.color)
      # |> assign(:users, M7state.get.users)
      |> assign(:users, %{})
      |> assign(:token, Phoenix.Controller.get_csrf_token())
      |> assign(:y, M8.t)
      # |> assign(:x, session)
    {:ok, updated}
  end

  def handle_info(:update, socket) do
    {:ok, u} = M7state.get_user(socket.assigns.uid)
    Process.send_after(self(), :update, 25)
    {:noreply, assign(socket, :y, M8.t)
    |> assign(:users, %{})
    |> assign(:info, u.info)
    |> assign(:color, u.color)


  }
  end

  def handle_event("validate", p, socket) do
    [h|_] = p["_target"]
    IO.inspect h
    socket = socket
    |> assign(:"#{h}", p[h])

    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""



<style> body {background-color: <%= @color %>;} </style>
<span style="
 font-size: 20px;
    color: yellow;
    "> <%= @uid %>::<%= @user %></span>


<a href="/">aaaaaa</a>
<span style="
 font-size: 20px;
    color: yellow;
    "> <%= @info %></span>
    <div
   style="
  # position: absolute;
    ">
<form action="/reg" method="POST" >

    <input type="hidden" value={"#{@token}"} name="_csrf_token"/>
    <input type="text" size="8" value={"#{@name}"} phx-change="validate" name="name" id="name" placeholder="...name"  maxlength="99">
    <input type="text" size="8"value={"#{@pw}"}  name="pw" id="pw" phx-change="validate" placeholder="...pw"  maxlength="99">
    <button>Рег</button>


</form>

<form action="/log" method="POST" >

    <input type="hidden" value={"#{@token}"} name="_csrf_token"/>
    <input type="text" size="8" name="id" id="id" value={"#{@id}"} phx-change="validate" placeholder="...id"  maxlength="99">
    <input type="text" size="8" name="key" id="key" value={"#{@key}"} phx-change="validate" placeholder="...key"  maxlength="99">
    <button>Вход</button>
</form>
</div>
<%!-- <form action="/logout" method="POST" >
<input type="hidden" value={"#{@token}"} name="_csrf_token"/>

    <button  name="log" value="out">Выхд</button>

</form> --%>

<.form let={f} for={@changeset}>
  <%= text_input f, :name %>
</.form>

<%= for {k, v} <- @users do %>
<%!-- <%= content_tag :span, "<111>" %> --%>
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
        <span style={"

font-size: 20px;
color: lightblue;

 "}><%=
  v.pw
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

defmodule User do
  use Ecto.Schema

  import Ecto.Changeset

  schema "users" do
    field :name, :string
    field :email
    field :age, :integer
  end

  def changeset(user, params \\ %{}) do
    user
    |> cast(params, [:name, :email, :age])
    |> validate_required([:name, :email])
    |> validate_format(:email, ~r/@/)
    |> validate_inclusion(:age, 18..100)
  end
end

defmodule Weather do
  use Ecto.Schema

  # weather is the DB table
  schema "weather" do
    field :city,    :string
    field :temp_lo, :integer
    field :temp_hi, :integer
    field :prcp,    :float, default: 0.0
  end
end

defmodule Sn22Web.Store do
  alias Sn22Web.Presence
  use Sn22Web, :live_view



  def mount(p, %{"user" => user}, socket) do
    if connected?(socket), do:
    :timer.send_interval(1000, :update)

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
      |> assign(:color, u.color)
      |> assign(:color2, u.color2)
      # |> assign(:users, M7state.get.users)
      |> assign(:users, %{})
      |> assign(:token, Phoenix.Controller.get_csrf_token())
      |> assign(:y, M8.t)
      # |> assign(:x, session)
    {:ok, updated}
  end

  def handle_info(:update, socket) do
    {:ok, u} = M7state.get_user(socket.assigns.uid)
    # Process.send_after(self(), :update, 1000)
    {:noreply, assign(socket, :y, M8.t)
    |> assign(:users, M7state.get.users)
    |> assign(:info, u.info)
    |> assign(:color, u.color)
    |> assign(:color2, u.color2)

  }
  end

  def handle_event("validate", p, socket) do
    [t|_] = p["_target"]
    IO.inspect p[t]
    IO.inspect t
    IO.inspect :"#{t}"
    {:noreply, assign(socket, :"#{t}", p[t])}

  end

  def handle_event("color", p, socket) do
    [t|_] = p["_target"]
    # IO.inspect p
    M7state.put socket.assigns.uid, :"#{t}", p[t]
    Process.send_after(self(), :update, 1)
    {:noreply, assign(socket, :"#{t}", p[t])}
  end

  def render(assigns) do
    ~H"""

<form>
<%= f = form_for :user, "/", [phx_submit: "submit"] %>
  <%= text_input f, :name %>
  <%= color_input f, :color %>
</form>

<style> body {
  font-size: 24px;
  background-color: <%= @color %>;} </style>
<span style="
 font-size: 20px;
    color: magenta;
    "> <%= @uid %>::<%= @user %></span>

<a href="/">aaaaaa</a>
<span style="
 font-size: 20px;
    color: yellow;
    "> <%= @info %></span>

<form action="/reg" method="POST" >

    <input type="hidden" value={"#{@token}"} name="_csrf_token"/>
    <input type="text" size="8" value={"#{@name}"} phx-change="validate" name="name" id="name" placeholder="...name"  maxlength="99">
    <input type="text" size="8"value={"#{@pw}"}  name="pw" id="pw" phx-change="validate" placeholder="...pw"  maxlength="99">
    <button>Рег</button>
    <input type="color" name="color" value={"#{@color}"} phx-change="color" >
    <input type="color" name="color2" value={"#{@color2}"} phx-change="color" >


</form>

<form action="/log" method="POST" >

    <input type="hidden" value={"#{@token}"} name="_csrf_token"/>
    <input autofocus type="text" size="8" name="id" id="id" value={"#{@id}"} phx-change="validate" placeholder="...id"  maxlength="99">
    <input type="text" size="8" name="key" id="key" value={"#{@key}"} phx-change="validate" placeholder="...key"  maxlength="99">
    <button>Вход</button>

</form>

<br>
<%=
  s = Store.give Store.init, 1, 2, "🍏";
    s = Store.bar s, 1, 2, "🍎", "🍏"; inspect [s.log, s]
 %>


<%!-- <form action="/logout" method="POST" >
<input type="hidden" value={"#{@token}"} name="_csrf_token"/>

    <button  name="log" value="out">Выхд</button>

</form> --%>

<.form let={f} for={:color} phx-change="validate">
   <%!-- <%= checkbox(f, :famous) %> --%>
   <%!-- <%= color_input(f, :color) %> --%>
  <%!-- <%= text_input f, :name %> --%>
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
    color: magenta;

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
<pre style={"
user-select: none;
pointer-events: none;
position: absolute; top: 232px;
font-family:monospace;
color: #{@color2};
  line-height: 4px;
  font-size: 8px;
  "}><%= @y %></pre>


<script>


</script>

    """



  end
end

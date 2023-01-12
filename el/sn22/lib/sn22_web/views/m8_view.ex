
defmodule PComp do
  use Phoenix.Component

  def greet(assigns) do
    ~H"""
    <p>Hello, <%= @name %>!</p>
    """
  end
end

defmodule Sn22Web.V2 do
  alias Sn22Web.Presence
  use Sn22Web, :live_view
  use Phoenix.Component
  alias Phoenix.Socket.Broadcast

  def greet(assigns) do
    ~H"""
    <p>Hello, <%= @name %>!</p>
    """
  end


  def mount(p, %{"user" => user}, socket) do
    if connected?(socket), do:
    :timer.send_interval(111, :update)
    Phoenix.PubSub.subscribe(Sn22.PubSub, "aa")

    # :timer.send_interval(13, {:item_updated, 1})

  {:ok, u} = M7state.get_user(user)

    # IO.inspect u;
  # M7state.put u.id, :casts, %{1 => %{x: 1, y: 2}}

    updated =
      socket
      |> assign(:x, 50)
      |> assign(:y, 50)
      |> assign(:user, u.name)
      |> assign(:u, u)
      |> assign(:fv, 11)
      |> assign(:vip, u.vip)
      |> assign(:uid, u.id)
      |> assign(:cs, u.casts)
      |> assign(:chips, u.chips)
      |> assign(:schips, M7state.get.chips)
      |> assign(:paint, u.paint)
      |> assign(:cs, u.casts)
      |> assign(:p, u.point)
      |> assign(:board, u.board)
      |> assign(:ch, Enum.random [2,3,1])
      # |> push_event( "highlight",%{})
      # |> handle_joins(Presence.list("aa"))

      # |> assign(:x, session)
    {:ok, updated}
  end

  def handle_event("clear", _value, socket) do
    M7state.put socket.assigns.uid, :board, %{socket.assigns.board | pixels: %{}, clra: False}
    :timer.apply_after 444, M7state, :clra, [socket.assigns.uid]
    Phoenix.PubSub.broadcast(Sn22.PubSub, "aa", :clear)
    {:noreply, socket |> push_event("clear",%{})}
  end

  def handle_event("getink", _value, socket) do
    {:ok, u} = M7state.get_user(socket.assigns.uid)
    [h | t] = u.chips
    M7state.put :chips, [h]++M7state.get.chips
    M7state.put socket.assigns.uid, :chips, t
    M7state.put socket.assigns.uid, :paint, u.paint+100
    {:noreply, socket}
  end

  def handle_event("load", _value, socket) do
    M7state.load();
    send(self, :update)
     {:noreply, socket |> push_event("clear",%{})} end
  def handle_event("save", _value, socket) do
    M7state.save();
    {:noreply, socket} end

  def handle_event("reset", _value, socket) do
    send(self, :update)

      M7state.reset();
    {:noreply, socket |> push_event("clear",%{})} end


  def handle_event("getchip", _value, socket) do
    {:ok, u} = M7state.get_user(socket.assigns.uid)
    [h | t] = M7state.get.chips
    M7state.put :chips, t
    M7state.put socket.assigns.uid, :chips,  [h]++u.chips
    M7state.put socket.assigns.uid, :chipa, u.chipa+1
    {:noreply, socket}
  end

  def handle_info(:clear, socket) do
    {:noreply, socket |> push_event("clear",%{})}
  end

  def handle_info(:update, socket) do
    {:ok, u} = M7state.get_user(socket.assigns.uid)
    # Process.send_after(self(), :update, 1000)
    {:noreply, socket

    |> assign(:cs, u.casts)
    |>  push_event("highlight", %{})
    |> assign(:p, u.point)
    |> assign(:u, u)

    |> assign(:board, u.board)
    |> assign(:chips, u.chips)
    |> assign(:schips, M7state.get.chips)
    |> assign(:paint, u.paint)

    # |> assign(:ch, 1)

  }
  end

  def handle_info(123, socket) do

    {:noreply, socket}
 end

  def handle_info({:item_updated, item}, socket) do
    {:noreply, push_event(socket, "highlight",
    %{x: item.x, y: item.y}
    )}
  end

  def handle_event("cursor-move", %{"mouse_x" => x, "mouse_y" => y}, socket) do
    IO.inspect {x,y};
    # Process.send_after(self(), :update, 1)

    M7state.put socket.assigns.uid, :casts,
    Map.put(socket.assigns.cs, socket.assigns.ch, %{x: x, y: y} )


    {:noreply,
      socket
    }
  end

  def paint(e, socket, u) do
    # IO.inspect e;
    a = socket.assigns
    {:ok, u} = M7state.get_user(socket.assigns.uid)

    M7state.draw socket.assigns.uid, e["x"], e["y"]
    # :timer.send_interval(13, {:item_updated, 1})
    send(self, {:item_updated, %{x: e["x"], y: e["y"]}})
    M7state.put socket.assigns.uid, :paint, u.paint-1;

  end

  def handle_event("aaa", e, socket) do
    {:ok, u} = M7state.get_user(socket.assigns.uid)
    if u.paint > 0, do: paint(e, socket, u)

    {:noreply,socket}

  end

  def handle_event("cur", e, socket) do
    {:ok, u} = M7state.get_user(socket.assigns.uid)
    M7state.put socket.assigns.uid, :board,
    Map.put(u.board, :cur,
      Map.put(u.board.cur, socket.assigns.uid, %{x: e["x"], y: e["y"]}));

    {:noreply,socket}
  end

  def render(assigns) do
    ~H"""
<style> body {
background-color: <%= "#796C4D" %>;
font-size: 16px;
} </style>
<%!-- <span style="
 font-size: 20px;
    color: magenta;
    "> <%=@uid %>::<%= @user %></span> --%>

<%!-- <.greet name={@fv}} /> --%>

<span><%= if @vip do "✔️" end %></span>
<span><%= @u.twitch.name || "_____" %></span>
<span><%= @u.twitch.key || "_____" %></span>
<br>

    <%!-- <%= inspect Store.init %>
    <form action="/aa">
  <label for="aa">:</label>
  <select name="aa" id="aa">
    <option value="1">1</option>

  </select>

  <input type="submit" value="Submit">
</form>
<p
   style="
   font-family:monospace;"> channel:  <%= @ch %>
    </p> --%>

    <canvas
    data-a={inspect (for {k, v} <- @board.pixels, do:
    [rem(k, 480), floor k/480]), limit: :infinity, charlists: :aslists}
    data-b={inspect (for {k, v} <- @board.pixels, do:
    [rem(k, 480), floor k/480]), limit: :infinity, charlists: :aslists}

     phx-hook="Aaa"
     id="canvas"  width="480" height="270" style=" size:200%;  user-select: none; cursor: none; color: green; border:solid gray 4px; touch-action:none">
  Your browser does not support canvas element.
</canvas>
<br>

<button phx-click="clear" disabled={@u.board.clra==False}>стр</button>
<button phx-click="getink" disabled={@chips==[]}>чрн</button>
<button phx-click="getchip" disabled={@schips==[]}>жт</button>

<form method="POST" action="https://yoomoney.ru/quickpay/confirm.xml">
    <input type="hidden" name="receiver" value="4100117845246172"/>
    <input type="hidden" name="label" value="1111"/>
    <input type="hidden" name="quickpay-form" value="button"/>
    <input  name="sum" value={"#{@fv}"} type="number" min="1" max="9999"/>
    <%!-- <label><input type="radio" name="paymentType" value="PC"/>ЮMoney</label>
    <label><input type="radio" name="paymentType" value="AC"/>Банковской картой</label> --%>
    <input  type="submit" disabled="true" value="пк"/>
    <input  type="submit"  value="пк"/>
</form>

<%!-- <iframe src="https://yoomoney.ru/quickpay/fundraise/button?billNumber=AdFIUwGWMKk.221228&" width="330" height="50" frameborder="0" allowtransparency="true" scrolling="no"></iframe>​ --%>
<%!-- <button phx-click="load" >зг</button>
<button phx-click="save" >схр</button>
<button phx-click="reset" >прꙖⰀ</button> --%>
<br>




<span><%= @paint %></span>
<span><%= @u.chipa %></span>

    <span><%= inspect @chips %></span>
    <span style="color: black; font-size: 12px;"><%= inspect @schips, limit: 111 %></span>
    <%!-- <span id="cursors" phx-hook="TrackClientCursor"
   style="
   font-family:monospace;"> <%= inspect @cs %>
    </span> --%>
        <span id="aaa"
   style=" font-size: 12px;
   font-family:monospace;"> <%= inspect @board %>
    </span>
    <%!-- <span
   style="
   font-family:monospace;"> <%= inspect @board %>
    </span> --%>
    <%!-- <img src="https://cdn.discordapp.com/attachments/1008571225309728878/1051810192980979772/sunraylmtd_jrpg_anime_character_male_handling_a_weapon_wearing__fae0332f-d0ef-4e24-93a7-3833e4d87102.png"> --%>
    <img src="https://cdn.discordapp.com/attachments/1008571225309728878/1051413972961738762/sunraylmtd_pavement_autumn_leaves_puddles_reflect_a_town_aa926f07-5425-4775-aa3f-4e5e6540dc32.png">
    <img src="https://cdn.discordapp.com/attachments/1051412740494864395/1051606549472231484/sunraylmtd_jrpg_anime_character_male_handling_a_weapon_wearing__fd5af909-2b42-4ef5-a633-9a4c2e7348de.png">
     <img src="https://cdn.discordapp.com/attachments/1051412740494864395/1051910845988348035/sunraylmtd_jrpg_anime_character_male_handling_a_weapon_wearing__fae0332f-d0ef-4e24-93a7-3833e4d87102.png">
<script>
const canvas = document.getElementById('canvas');
const ctx = canvas.getContext('2d');
ctx.globalAlpha = 1;


 l = <%=  inspect (for {k, v} <- @board.pixels,
  do: [rem(k, 480), floor k/480]),
limit: :infinity, charlists: :aslists %>

window.addEventListener(`phx:highlight`, (e) => {
  arr = document.getElementById('canvas').dataset.a;
    <%!-- console.log(document.getElementById('canvas').dataset.a); --%>
    <%!-- draw2(e.detail.x, e.detail.y); --%>
    draw3(JSON.parse(arr));
})
window.addEventListener(`phx:clear`, (e) => {

    ctx.clearRect(0, 0, canvas.width, canvas.height);
    draw();

})
document.addEventListener('pointermove', (e) => {

      const x = Math.floor( e.pageX);
      const y = Math.floor(e.pageY);
      const p = e.pressure;
      draw2(x, y);
    });

function draw2(x, y) {
  ctx.clearRect(0, 0, canvas.width, canvas.height);
  arr = document.getElementById('canvas').dataset.a;


draw3(JSON.parse(arr));

  ctx.fillStyle = "orange";
  ctx.fillRect(x-11,y-33,4,4);
  ctx.fillStyle = "black";
}
function draw4(x, y, c) {
  ctx.fillStyle = c;
  ctx.fillRect(x,y,4,4);
}
function draw3(arr) {


    arr.forEach(e =>
    draw4(e[0],e[1],"black"));
}

function draw() {
  const canvas = document.getElementById('canvas');
  if (canvas.getContext) {
    const ctx = canvas.getContext('2d');
    const array1 = ['a', 'b', 'c'];

    ctx.fillStyle = "gray";

    for (var i = 0; i < 111; i++) {
    var x = Math.floor(Math.random() * 1111);
    var y = Math.floor(Math.random() * 222);
    array1.forEach(element => ctx.fillRect(x,y,3,4));
    ctx.fillRect(x,y,1,41);
  }
  ctx.fillStyle = "black";

  }
}
<%!-- draw2( <%= @board.cur.x  %>, <%= @board.cur.y %>); --%>
draw();

arr = document.getElementById('canvas').dataset.a
console.log(l)
draw3(JSON.parse(arr));
</script>
    """
  end
end

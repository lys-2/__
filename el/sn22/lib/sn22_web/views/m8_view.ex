
defmodule Sn22Web.V2 do
  alias Sn22Web.Presence
  use Sn22Web, :live_view

  def mount(p, %{"user" => user}, socket) do
    if connected?(socket), do:
    :timer.send_interval(25, :update)
    # :timer.send_interval(13, {:item_updated, 1})

  {:ok, u} = M7state.get_user(user)
    # IO.inspect u;
  # M7state.put u.id, :casts, %{1 => %{x: 1, y: 2}}

    updated =
      socket
      |> assign(:x, 50)
      |> assign(:y, 50)
      |> assign(:user, u.name)
      |> assign(:uid, u.id)
      |> assign(:cs, u.casts)
      |> assign(:p, u.point)
      |> assign(:board, u.board)
      |> assign(:ch, Enum.random [2,3,1])
      |> push_event( "highlight",
    %{}
    )

      # |> assign(:x, session)
    {:ok, updated}
  end

  def handle_info(:update, socket) do
    {:ok, u} = M7state.get_user(socket.assigns.uid)
    # Process.send_after(self(), :update, 1000)
    {:noreply, socket

    |> assign(:cs, u.casts)
    # |>  push_event("highlight", %{})
    |> assign(:p, u.point)
    |> assign(:board, u.board)
    |> push_event( "highlight",
    %{x: 1, y: 2}
    )
    # |> assign(:ch, 1)

  }
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

  def handle_event("aaa", e, socket) do
    {:ok, u} = M7state.get_user(socket.assigns.uid)
    IO.inspect e;
    M7state.put socket.assigns.uid, :point, e;
    M7state.put socket.assigns.uid, :board,
    Map.put(u.board, e["x"]+e["y"]*480, e["p"]);
    # :timer.send_interval(13, {:item_updated, 1})
    send(self, {:item_updated, %{x: e["x"], y: e["y"]}})

    {:noreply,socket}

  end

  def render(assigns) do
    ~H"""
<style> body {
background-color: <%= "darkgreen" %>;
font-size: 24px;
} </style>

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
    data-a={inspect (for {k, v} <- @board, do: [rem(k, 480), floor k/480]), limit: :infinity, charlists: :aslists}

     phx-hook="Aaa"
     id="canvas" width="480" height="270" style="color: green; border:solid black 2px; touch-action:none">
  Your browser does not support canvas element.
</canvas>
<br>
    <%!-- <span id="cursors" phx-hook="TrackClientCursor"
   style="
   font-family:monospace;"> <%= inspect @cs %>
    </span> --%>
        <span id="aaa"
   style="
   font-family:monospace;"> <%= inspect @board %>
    </span>
    <%!-- <span
   style="
   font-family:monospace;"> <%= inspect @board %>
    </span> --%>
<script>
 l = <%=  inspect (for {k, v} <- @board,
  do: [rem(k, 480), floor k/480]), limit: :infinity, charlists: :aslists %>

window.addEventListener(`phx:highlight`, (e) => {
  arr = document.getElementById('canvas').dataset.a;
    <%!-- console.log(document.getElementById('canvas').dataset.a); --%>
    <%!-- draw2(e.detail.x, e.detail.y); --%>
    draw3(JSON.parse(arr));
})
const canvas = document.getElementById('canvas');
const ctx = canvas.getContext('2d');

function draw2(x, y) {
    ctx.fillRect(x,y,4,4);

}
function draw3(arr) {

  <%!-- console.log(arr); --%>
    arr.forEach(e => ctx.fillRect(e[0],e[1],4,4));
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
draw2(11, 12);
draw();

arr = document.getElementById('canvas').dataset.a
console.log(l)
draw3(JSON.parse(arr));
</script>
    """
  end
end

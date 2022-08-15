defmodule Sn22Web.V1 do
  # In Phoenix v1.6+ apps, the line below should be: use MyAppWeb, :live_view
  use Phoenix.LiveView

  def render(assigns) do
    ~H"""
    <button phx-click="inc_temperature" phx-window-keyup="update_temp">+</button>
    aaa <%= @aaa;  inspect((:h3.k_ring_distances 577375545977733119,
     1), limit: 9999) %>
     <p><%= @aaa; cs2 = :h3.k_ring(577094071001022463,
     1);
     for c <- cs2, do: {:h3.get_base_cell(c), :h3.k_ring(c, 1)}
     |> inspect
     %>
     </p>
     <p><%= @name %></p>
     <span id="q">Q</span>
     <span id="w">W</span>
     <span id="e">E</span>
     <span id="r">R</span>
     <script>
     document.addEventListener("keydown", keyDownHandler, false);
      document.addEventListener("keyup", keyUpHandler, false);
      function keyDownHandler(e) {
        console.log(e);
        if (e.key === "e" || e.key === "ArrowRight") {
          document.getElementById("e").style.color = "blue";
        } else if (e.key === "q" || e.key === "ArrowLeft") {
          document.getElementById("q").style.color = "blue";
        }
      else if (e.key === "w" || e.key === "ArrowLeft") {
        document.getElementById("w").style.color = "blue";
      }
    else if (e.key === "r" || e.key === "ArrowLeft") {
      document.getElementById("r").style.color = "blue";
    }
      }



      function keyUpHandler(e) {
        if (e.key === "e" || e.key === "ArrowRight") {
          document.getElementById("e").style.color = "green";
        } else if (e.key === "q" || e.key === "ArrowLeft") {
          document.getElementById("q").style.color = "green";
        }
      else if (e.key === "w" || e.key === "ArrowLeft") {
        document.getElementById("w").style.color = "green";
      }
    else if (e.key === "r" || e.key === "ArrowLeft") {
      document.getElementById("r").style.color = "green";
    }
      }
     </script>
    """
  end

  def mount(_params, _, socket) do
    if connected?(socket), do: Process.send_after(self(), :update, 1000)

    put_flash(socket, :info, "It worked!");
    {:ok, assign(socket, %{aaa: M2.get, name:
    (for _ <- 1..10, into: "", do: <<Enum.random('0123456789abcdef')>>)
    })};

  end

  def handle_info(:update, socket) do
    Process.send_after(self(), :update, 1000);
    # IO.inspect 1;
    {:noreply, assign(socket, :aaa, inspect M2.get2 M2.get)}
  end

  def handle_event("inc_temperature", _value, socket) do
    IO.puts 123123123;
    {:noreply, assign(socket, %{})}
  end

  def handle_event("update_temp", %{"key" => key}, socket) do
    IO.puts inspect {key, socket.assigns.name};
    {:noreply, assign(socket, :key, key)}
  end

end

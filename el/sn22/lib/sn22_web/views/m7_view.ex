defmodule Sn22Web.Store do

  # In Phoenix v1.6+ apps, the line below should be: use MyAppWeb, :live_view
  use Sn22Web, :live_view

  def mount(_params, _session, socket) do
    if connected?(socket), do:
   Process.send_after(self(), :update, 1)

    updated =
      socket
      |> assign(:x, :rand.uniform)
      |> assign(:y, M8.t )
    {:ok, updated}
  end

  def handle_info(:update, socket) do
    Process.send_after(self(), :update, 25)
    {:noreply, assign(socket, :y, M8.t)}
  end


  def render(assigns) do
    ~H"""
    <pre><%= @x %></pre>
<pre style="
font-family:monospace;
  line-height: 8px;
  font-size: 16px;"><%= @y %></pre>
    <input type="file" />

      <script>
      window.addEventListener('pointerdown', (event) => {
        console.log(event);



      }, true);


      </script>

    """
  end
end

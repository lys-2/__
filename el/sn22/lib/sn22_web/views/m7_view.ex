defmodule Sn22Web.Store do

  # In Phoenix v1.6+ apps, the line below should be: use MyAppWeb, :live_view
  use Sn22Web, :live_view

  def mount(_params, _session, socket) do
    updated =
      socket
      |> assign(:x, 50)
      |> assign(:y, M8.t )
    {:ok, updated}
  end


  def render(assigns) do
    ~H"""
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

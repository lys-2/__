defmodule Sn22Web.Store do

  # In Phoenix v1.6+ apps, the line below should be: use MyAppWeb, :live_view
  use Sn22Web, :live_view

  def mount(_params, _session, socket) do
    updated =
      socket
      |> assign(:x, 50)
      |> assign(:y, 50)
    {:ok, updated}
  end

  def handle_event("cursor-move", %{"x" => x, "y" => y}, socket) do
    IO.puts(x);
    IO.puts(y);
    IO.inspect socket
    updated =
      socket
      |> assign(:x, x)
      |> assign(:y, y)
      IO.inspect updated
    {:noreply, updated}
  end

  def render(assigns) do
    ~H"""
    <span style={"font-family:monospace;
    display: inline-block;
    position: absolute; top: "<>
    "#{@y}"
    <>"px; left: "<>
    "#{@x}"
    <>"px; "<>
    "filter: hue-rotate("<>
    "#{111}"
    <>"deg);
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

    }><%= "🦎" %></span>
    <ul class="list-none" id="cursors" phx-hook="TrackClientCursor"> </ul>
    """
  end
end

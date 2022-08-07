defmodule Sn22Web.V1 do
  # In Phoenix v1.6+ apps, the line below should be: use MyAppWeb, :live_view
  use Phoenix.LiveView

  def render(assigns) do
    ~H"""
    aaa <%= @aaa %>
    """
  end

  def mount(_params, _, socket) do
    if connected?(socket), do: Process.send_after(self(), :update, 1000)
    IO.inspect 1;

    put_flash(socket, :info, "It worked!");
    {:ok, assign(socket, :aaa, M2.get)};

  end

  def handle_info(:update, socket) do
    Process.send_after(self(), :update, 1000);
    IO.inspect 1;
    {:noreply, assign(socket, :aaa, inspect M2.get2 M2.get)}
  end

end

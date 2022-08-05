defmodule V1 do
  # In Phoenix v1.6+ apps, the line below should be: use MyAppWeb, :live_view
  use Sn22Web, :live_view

  def render(assigns) do
    ~H"""
    Current temperature: <%= @temperature %>
    """
  end

  def mount(_params, %{}, socket) do
    Process.send_after(self(), :update, 100)
    put_flash(socket, :info, "It worked!")
    {:ok, assign(socket, :temperature, M2.get<>inspect socket)};

  end

  def handle_info(:update, socket) do
    Process.send_after(self(), :update, 100);
    IO.inspect 1;
    {:noreply, assign(socket, :temperature, M2.get)}
  end

end

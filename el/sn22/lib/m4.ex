defmodule M4 do
  use GenServer

  def start_link(s, name) do
    GenServer.start(__MODULE__, s, name: name)
  end

  # GenServer callbacks

  def handle_call(:get, _from, s) do
    {:reply, s, s}
  end

  def handle_cast({:new, s1}, s) do
    {:noreply, s1}
  end



  def new(name, s) do
    GenServer.cast(s, {:new, s})
  end

  def get(s) do
    GenServer.call(s, :get)
  end

  def subtract(a, b) do
    a - b
  end
end

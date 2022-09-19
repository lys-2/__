defmodule M4 do
  use GenServer

  defstruct [
    :id, :timer,
   :name, :bio, :twname, :twmsg, :twmsgr, :stat
  ]

  @count 1111

  def init(s) do
    # process input and compute result
    # IO.puts(s);

    {:ok, t} = :timer.exit_after(Enum.random(1000..20000), 1);
    {:ok, %{s | timer: t}}
    end

  # def terminate(reason, state) do

  #   IO.puts(reason);

  #   end

  def handle_call(:get, _from, s) do
    {:reply, s, s}
  end

  def handle_cast({:up, s1}, 1) do
    {:noreply, s1}
  end

  ####################

  def start() do
    for e <- 1..@count, do:
    GenServer.start(__MODULE__, %M4{id: e},
     name: String.to_atom "m4_#{e}")

  end

  def update(name, s) do
    GenServer.cast(name, {:time, s})
  end

  def get(name) do
    if Process.whereis name do
     GenServer.call(name, :get)
    else %M4{} end

  end

  def get2() do
    for e <- 1..@count,
     do: get String.to_atom "m4_#{e}"
  end

  def subtract(a, b) do
    a - b
  end
end

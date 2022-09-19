defmodule M4s do
  use GenServer

  def init(s) do
    # process input and compute result
    # IO.puts(s);
    M4.start;
    :timer.apply_interval(21000, M4, :start, [])

    end

    def start() do

      GenServer.start(__MODULE__, 1,
       name: :m4s)

    end

end
defmodule M4 do
  use GenServer

  defstruct [
    :id, :timer, :color, :tilt, :size, :left, :top,
   :name, :bio, :twname, :twmsg, :twmsgr, :stat
  ]

  @count 3333

  def init(s) do
    # process input and compute result
    # IO.puts(s);

    {:ok, {_, t}} = :timer.exit_after(Enum.random(1000..20000), 1);
    {:ok, %{s | timer: t, color: :rand.uniform(255),
    size: :rand.uniform(6)+2,
    top: :rand.uniform(540)+300,
    left: :rand.uniform(960),
    tilt: :rand.uniform(8)-3
    }}
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
    end

  end

  def get2() do
    ls = for e <- 1..@count,
     do: get String.to_atom("m4_#{e}");
     ls |> Enum.filter fn x -> x != nil end

  end

  def subtract(a, b) do
    a - b
  end
end

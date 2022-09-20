defmodule M4s do
  use GenServer

  def init(s) do
    # process input and compute result
    # IO.puts(s);
    M4.start;
    :timer.apply_interval(3000, M4, :start, [])

    end

    def start() do

      GenServer.start(__MODULE__, 1,
       name: :m4s)

    end

end
defmodule M4 do
  use GenServer

  defstruct [
    :id, :timer, :color, :tilt, :size, :left, :top, :mirror,
   :name, :twname, :twmsg, :twmsgr, :stat
  ]

  @count 99

  def init(s) do
    # process input and compute result
    # IO.puts(s);
    # :timer.send_after(2000, GenServer, :cast, [self, :up])

    {:ok, {_, t}} = :timer.exit_after(Enum.random(1000..2999), 1);

    :timer.send_interval(10, self, :tick);

    {:ok, %{s | timer: t, color: :rand.uniform(255),
    size: :rand.uniform(16)+4,
    top: :rand.uniform(540)+300,
    left: :rand.uniform(960),
    tilt: :rand.uniform(8)-3,
    color: :rand.uniform(20),
    mirror: Enum.random([-1,1])
    }}
    end

  # def terminate(reason, state) do

  #   IO.puts(reason);

  #   end

  def handle_call(:get, _from, s) do
    {:reply, s, s}
  end

  def handle_info(:tick, s) do
    {:noreply,
     %{s |
    size: s.size+0.1,
    top: s.top+Enum.random(-12..12),
    left: s.left+Enum.random(-12..12)
    }}
  end

  ####################

  def start() do
    for e <- 1..@count, do:
    GenServer.start(__MODULE__, %M4{id: e},
     name: String.to_atom "m4_#{e}")

  end

  def update(name, s) do
    GenServer.cast(name, :tick)
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

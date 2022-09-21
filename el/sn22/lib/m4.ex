defmodule M4s do
  use GenServer

  def init(s) do
    # process input and compute result
    # IO.puts(s);
    M4.start;
    :timer.apply_interval(15000, M4, :start, [])

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
    :rotate,
   :name, :twname, :twmsg, :twmsgr, :stat
  ]

  @count 70

  def init(s) do
    # process input and compute result
    # IO.puts(s);
    # :timer.send_after(2000, GenServer, :cast, [self, :up])

    {:ok, {_, t}} = :timer.exit_after(Enum.random(1000..14999), 1);

    :timer.send_interval(44, self, :tick);


    {:ok, %{s |
    timer: t,
    size: :rand.uniform(1)+2,
    top: :rand.uniform(540)+300,
    left: :rand.uniform(960),
    tilt: :rand.uniform(8)-3,
    rotate: :rand.uniform(360),
    color: Enum.random([:rand.uniform(10)-20,
        250+:rand.uniform(10)-20]),
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
    rotate: s.rotate+Enum.random([0,0,0,0,0,0,0,:rand.uniform(20)-40]),
    size: s.size+Enum.random([0,0,0,0,0,:rand.uniform(7)]),
    top: s.top+:math.cos(3.1415*(s.rotate/180.0))*-5,
    left: s.left+:math.sin(3.1415*s.rotate/180.0)*5*s.mirror
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

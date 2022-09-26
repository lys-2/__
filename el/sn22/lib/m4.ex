defmodule M4 do
  use GenServer

  defstruct [
    :id,
    :timer,
    :color,
    :tilt,
    :size,
    :left,
    :top,
    :mirror,
    :rotate,
    :name,
    :twname,
    twmsg: [],
    twmsgr: [],
    twmsgc: 0,
    twmsgrc: 0,
    chips: 0,
    priv: 0
  ]

  @count 99

  def init(s) do
    # process input and compute result
    # IO.puts(s);
    # :timer.send_after(2000, GenServer, :cast, [self, :up])

    {:ok, {_, t}} = :timer.exit_after(Enum.random(10000..30000), 1)

    :timer.send_interval(125, self, :tick)

    {:ok,
     %{
       s
       | timer: t,
         size: :rand.uniform(1) + 2,
         top: :rand.uniform(540) + 300,
         left: :rand.uniform(960),
         tilt: :rand.uniform(8) - 3,
         rotate: :rand.uniform(360),
         color: Enum.random([:rand.uniform(10) - 20, 250 + :rand.uniform(10) - 20]),
         mirror: Enum.random([-1, 1])
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
     %{
       s
       | rotate: s.rotate + Enum.random([0, 0, 0, 0, 0, 0, 0, :rand.uniform(120) - 60]),
         size: s.size + Enum.random([0, 0, 0, 0, 0, :rand.uniform(7)]),
         top: s.top + :math.cos(3.1415 * (s.rotate / 180.0)) * -5,
         left: s.left + :math.sin(3.1415 * s.rotate / 180.0) * 5 * s.mirror
     }}
  end

  ####################

  def start() do
    for e <- 1..@count,
        do: GenServer.start(__MODULE__, %M4{id: e}, name: String.to_atom("m4_#{e}"))
  end

  def update(name, s) do
    GenServer.cast(name, :tick)
  end

  def get(name) do
    if Process.whereis(name) do
      GenServer.call(name, :get)
    end
  end

  def get2() do
    ls =
      for e <- 1..16,
          do: get(String.to_atom("m4_#{e}"))

    ls |> Enum.filter(fn x -> x != nil end)
  end

  def subtract(a, b) do
    a - b
  end
end

defmodule M4c do
  use GenServer

  defstruct idc: 1, st: %{}, tm: nil
  @path  "../../../s"

  # Client

  def start() do
    GenServer.start(__MODULE__, nil, name: :cache)
  end

  def get(p) do
    if Process.whereis :cache do
    GenServer.call(p, :get)
    else
      %{}
    end
  end

  def put(p, m) do
    GenServer.cast(p, {:put, m})
  end

  # Server (callbacks)

  def init(_s) do
    put(self, {"1","2",3})
    case File.read(@path) do
      {:ok, f} -> {:ok, load}
      _ -> {:ok, %M4c{}}
    end
  end

  def handle_cast({:put, m}, s) do
    {:noreply, up(s, m)}
  end

  def handle_call(:get, _p, s) do
    {:reply, s.st, s}
  end

def save(s) do File.write(@path, :erlang.term_to_binary(s)) end
def load() do :erlang.binary_to_term File.read!(@path) end
def load(:b) do File.read!(@path) end

  def up(s, {rc, sn, m}) do

    s = add s, rc;
    s = add s, sn;

    {rc, sn} = {Map.fetch!(s.st,rc), Map.fetch!(s.st,sn)}

    # s = %M4c{s | st: %{s.st | %M4{rc | twmsgr: 1}}};
    # s = %M4c{s | st: %{s.st | %M4{sn | twmsg: 1}}};
    st = 1
    s = %M4c{s | st: st};
    save s;
    s

  end

  def add(s, u) do
    if not Map.has_key? s.st, u do
        %M4c{idc: s.idc + 1,
        st: Map.put(s.st, u, %M4{name: Faker.Pokemon.name, id: s.idc})}
    else
        s
    end
  end

end

defmodule M4s do
  use GenServer

  def init(s) do
    # process input and compute result
    # IO.puts(s);
    M4.start()
    :timer.apply_interval(30000, M4, :start, [])
    {:ok, s}
  end

  def start() do
    GenServer.start(__MODULE__, 1, name: :m4s)
  end
end

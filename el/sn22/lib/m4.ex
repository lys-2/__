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

    {:ok, {_, t}} = :timer.exit_after(Enum.random(1000..3000), 1)

    :timer.send_interval(250, self, :tick)

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

  defstruct uc: 0, idc: 1

  # Client

  def start() do
    GenServer.start(__MODULE__, {%{}, %M4c{}}, name: :cache)
  end

  def get(p) do
    GenServer.call(p, :get)
  end

  def put(p, m) do
    GenServer.cast(p, {:put, m})
  end

  # Server (callbacks)

  def init(s) do
    {:ok, s}
  end

  def handle_cast({:put, m}, s) do
    {:noreply, up(s, m)}
  end

  def handle_call(:get, p, s) do
    {:reply, elem(s, 0), s}
  end

  def up(s, {rc, sn, m}) do
    s = add s, rc;
    s = add s, sn;
    s
  end

  def add({s, st}, u) do
    if not Map.has_key? s, u do
      {Map.put(s, u, %M4{
        name: Faker.Pokemon.name,
         id: st.idc
         }), %M4c{idc: st.idc + 1}}
    else
        {s, st}
    end
  end

  def update(s, {sn, rc, m}) do
    s2 = update2(s, sn, :sn)
    update2(s2, rc, :rc)
  end

  def update2(s, u, t) do
    case {Map.has_key?(s, u), t} do
      {true, :rc} ->
        {rc, sn} = Map.fetch!(s, u)
        Map.put(s, u, {rc, sn + 1})

      {true, :sn} ->
        {rc, sn} = Map.fetch!(s, u)
        Map.put(s, u, {rc + 1, sn})

      {_, :rc} ->
        Map.put(s, u, {0, 1})

      {_, :sn} ->
        Map.put(s, u, {1, 0})
    end
  end
end

defmodule M4s do
  use GenServer

  def init(s) do
    # process input and compute result
    # IO.puts(s);
    M4.start()
    :timer.apply_interval(3000, M4, :start, [])
    {:ok, s}
  end

  def start() do
    GenServer.start(__MODULE__, 1, name: :m4s)
  end
end

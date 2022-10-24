
defmodule M7char do
  use GenServer
  # template

  defstruct [:cell, :hp, :id]

  def start_link(id) do GenServer.start_link __MODULE__, %M7char{},
   name: String.to_atom("ch#{id}") end

  def get() do GenServer.call :aa, :get end

  def init(s) do  inspect s; :timer.kill_after(4444); {:ok, %M7char{hp: 11}} end
  def handle_call(:get, _p, s) do {:reply, inspect([s, self]), s} end

  def spawn do 1 end

  # def sm

end

defmodule M7user do
  use GenServer
  # template

  defstruct [:id, :pw, :adm, :name, devices: %{}, clients: %{}, sessions: %{}]

  def start(i) do GenServer.start __MODULE__, %M7user{}, name: i2a(i) end
  def get(i) do GenServer.call i2a(i), :get end

  def init(s) do  inspect 111; {:ok, s} end
  def handle_call(:get, _p, s) do {:reply, s, s} end

  def i2a(i) do String.to_atom("u#{i}") end

  # def sm

end

defmodule M7cell do
  use GenServer
  # template

  defstruct  [:x, :y, :z, :id, type: 1, hue: 1, wp: %{}]

  # def start() do GenServer.start __MODULE__, %M4a{} end
  def start_link(s) do GenServer.start_link __MODULE__, s,
   name: String.to_atom("c#{s.id}") end

  def get(i) do n = String.to_atom("c#{i}"); case Process.whereis(n) do
    nil -> nil
    _ -> GenServer.call n, :get
  end end

  def ns() do GenServer.call self, :ns end

  def init(s) do  :timer.kill_after(44414); {:ok,
   %M7cell{s | wp: ns(1, 2, 3, 4)}} end

  def handle_call(:get, _p, s) do {:reply, s, s} end
  def handle_call(:ns, _p, s) do
   s = %M7cell{s | wp: ns(s.x, s.y, 64, 64)}; {:reply, s, s} end

  def get() do 1 end

  def ns(x, y, h, w) do %{
  n: {x, y-1},
  e: {x+1, y},
  s: {x, y+1},
  w: {x-1, y},
     }
     |> Map.filter(fn {k, {x, y}} -> inside?(x, y, h, w) end)
     |> Map.filter(fn {k, {x, y}} -> Process.whereis(String.to_atom("c#{x+(y*64)}")) end)
     |> Map.new(fn {k, {x, y}} -> {k, x+(y*64)} end)
    #  |> Enum.map(fn {k, {x, y}} -> x+(y*64) end)

    end

  def inside?(x, y, h, w) do x in 0..w and y in 0..h end


  # def sm

end

defmodule M7box do
  use GenServer

  defstruct items: []

  def start_link(_) do GenServer.start_link __MODULE__, %M4a{}, name: :aa end
  def get() do GenServer.call :aa, :get end

  def init(s) do  inspect s; :timer.exit_after(4444, :exit); {:ok, s} end
  def handle_call(:get, _p, s) do {:reply, inspect([s, self]), s} end

  # def sm

end

defmodule M7 do

  def parse do
        # m = ["../../data/m7.png", "../../data/m7a.png", "../../data/m7b.png"]
        m = ["../../data/m7.png"]
        {_, %{data: d}} = Pixels.read_file Enum.random m

        match = fn
          <<0, 255, 0, 255>> -> "✅"
          <<0, 0, 0, 255>> -> "⛚"
          <<0, 0, 111, 255>> -> "⛆"
          <<0, 0, 255, 255>> -> "⛽"
          <<0, 111, 0, 255>> -> "🍭"
          _ -> 0
        end

        d = for <<x::binary-4 <- d>>, do: match.(x); d = Enum.with_index d;
        # d = for <<x::binary-4 <- d>>, x != <<255,255,255,255>>, do: match.(x);
        d = d |> Enum.reject(fn {x, _} -> x == 0 end) |>
         Enum.map( fn {a, b}->
          %M7cell{type: a, id: b, x: rem(b,64), y: floor((b/64)),
           hue: ceil :rand.uniform(24)+b/(:rand.uniform(111)+1)} end);

           :dets.open_file(:dt, [type: :set]);
           :dets.insert(:dt, {1, d}); :dets.close(:dt); d


  end


end

defmodule M7state do
  use GenServer
  # template

  defstruct [users: %{}, cells: %{}, stats: %{user_counter: 1}]

  def start_link(i) do GenServer.start_link __MODULE__, %M7state{}, name: :M7state end
  def get() do GenServer.call :M7state, :get end
  def load() do GenServer.call :M7state, :load end
  def save() do GenServer.call :M7state, :save end
  def add_user(u) do GenServer.call :M7state, {:add_user, u} end
  def create_users() do GenServer.call :M7state, :create_users end
  def reset() do GenServer.call :M7state, :reset end

  def aaa, do: 1

  def init(s) do
  #  c = for e <- M7.parse do M7cell.start_link(e); end
  # File.cd "../../data"
  # {:ok, table} = :dets.open_file(:dt, [type: :set])
  s = save(s)
  # for e <- [] do M7cell.start_link(e); end
  # for e <- M7.parse do GenServer.call(String.to_atom("c#{e.id}"), :ns) end
  # :dets.open_file(:dt, [type: :set]);
  # [{_, s}] = :dets.lookup(:dt, 1); :dets.close(:dt);
  s = put_in(s.cells, M7.parse)

  for e <- s.cells do M7cell.start_link(e); end
  for e <- s.cells do GenServer.call(String.to_atom("c#{e.id}"), :ns) end

  #  s = M7user.start 1
#  {:ok, %__MODULE__{s | cells: c}} end
 {:ok, s} end

  def handle_call(:get, _p, s) do {:reply, s, s} end
  def handle_call(:load, _p, s) do {:reply, s, load(s)} end
  def handle_call(:save, _p, s) do {:reply, s, save(s)} end
  def handle_call({:add_user, u}, _p, s) do {:reply, :ok, add_user(s, u)} end
  def handle_call(:create_users, _p, s) do {:reply, create_users(s).users, create_users(s)} end
  def handle_call(:reset, _p, s) do {:reply, reset(s), reset(s)} end

  def i2a(i) do String.to_atom("c#{i}") end

  def rc() do M7state.get.cells |> Enum.random
  |> Map.get(:id) |> M7cell.get end

  def save(s) do
    File.write("../../data/M7", :erlang.term_to_binary s); s end
  def load(s) do case File.read("../../data/M7") do
    {:ok, f} -> :erlang.binary_to_term f
    _ -> nil end end

    def create_users(s) do
    # c = s.stats.user_counter;
      for e <- 1..11111, reduce: s do acc -> add_user(acc, %M7user{id: e}) end
    end

    def add_user(s, u) do
        s = put_in s.users, Map.put(s.users, :"u#{s.stats.user_counter}", u);
        update_in s.stats.user_counter, &(&1 + 1)
       end

  def reset(s), do: %M7state{}

end

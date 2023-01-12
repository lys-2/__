


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

defmodule Palette do defstruct [:colors] end

defmodule M7cast do defstruct [:colors] end

defmodule M7user do
  use GenServer
  # template

  defstruct [:id, :adm, :name, pw: "", devices: %{}, vip: false,
  casts: %{1 => %{x: 0, y: 0}}, point: %{x: 0, y: 0, p: 0}, twlog: %{},
  board: %{clra: True, pixels: %{}, cur: %{2 => %{x: 9, y: 22}}},
  chips: [], paint: 999, chipa: 0, bucket: [],
  ex: %{"count" => 1, "charge" => 1, 1 => 24, 2 => 12},
   b: 0.0, a: 0.0, twitch: %{name: nil, key: nil}, palette: %{},
  key: nil, info: nil, color: nil, color2: "#3BDE56"]

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

  def init(s) do
    # :timer.kill_after(111111);
   {:ok,
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
        {:ok, %StbImage{data: d}} = StbImage.read_file("../../data/m7.png")

        match = fn
          <<0, 255, 0, 255>> -> "✅"
          <<0, 0, 0, 255>> -> "⛚"
          <<0, 0, 111, 255>> -> "⛆"
          <<0, 0, 255, 255>> -> "🧽"
          <<0, 111, 0, 255>> -> "~"
          _ -> 0
        end

        d = for <<x::binary-4 <- d>>, do: match.(x); d = Enum.with_index d;
        # d = for <<x::binary-4 <- d>>, x != <<255,255,255,255>>, do: match.(x);
        d = d |> Enum.reject(fn {x, _} -> x == 0 end) |>
         Enum.map( fn {a, b}->
          %M7cell{type: a, id: b, x: rem(b,64), y: floor((b/64)),
           hue: ceil :rand.uniform(24)+b/(:rand.uniform(111)+12)} end);

           :dets.open_file(:dt, [type: :set]);
           :dets.insert(:dt, {1, d}); :dets.close(:dt); d
  end
end

defmodule M7state do
  use GenServer
  # template

  defstruct [users: %{}, cells: %{}, price: %{chip: 10}, inc: %{ymn: []},
  stats: %{user_counter: 1}, chips: (for e <- 1..30000, do: e), b: 0.0, c: 0.0,
   timers: [
    # {5000, M7state, :reset, []}
   ],
   rkeys: %{}]

  def start_link(i) do GenServer.start_link __MODULE__, %M7state{}, name: :M7state end
  def get() do GenServer.call :M7state, :get end
  def get_user(i) do GenServer.call :M7state, {:get_user, i} end
  def load() do GenServer.call :M7state, :load end
  def save() do GenServer.call :M7state, :save end
  def add_user(u) do GenServer.call :M7state, {:add_user, u} end
  def create_users(c) do GenServer.call :M7state, {:create_users, c} end
  def reset() do GenServer.call :M7state, :reset end
  def info(u, i) do GenServer.call :M7state, {:info, u, i} end
  def put(u, k, v) do GenServer.call :M7state, {:put, u, k, v} end
  def put(k, v) do GenServer.call :M7state, {:puts, k, v} end
  def clra(u) do GenServer.call :M7state, {:clra, u} end
  def draw(u, x, y) do GenServer.call :M7state, {:draw, u, x, y} end
  def play() do GenServer.call :M7state, {:play} end

  def aaa, do: 1

  def init(s) do
  #  c = for e <- M7.parse do M7cell.start_link(e); end
  # File.cd "../../data"
  # {:ok, table} = :dets.open_file(:dt, [type: :set])
  # s = save(s)
  # for e <- [] do M7cell.start_link(e); end
  # for e <- M7.parse do GenServer.call(String.to_atom("c#{e.id}"), :ns) end
  # :dets.open_file(:dt, [type: :set]);
  # [{_, s}] = :dets.lookup(:dt, 1); :dets.close(:dt);
  :timer.apply_interval(3000, M7state, :save, [])
  :timer.apply_interval(100, M7state, :tick, [])
  for {a,b,c,d} <- s.timers, do: :timer.apply_after(a,b,c,d)
  s = load s;
  s = put_in(s.cells, M7.parse)
  # s = put_in(s.cells, [])

  for e <- s.cells do M7cell.start_link(e); end
  for e <- s.cells do GenServer.call(String.to_atom("c#{e.id}"), :ns) end

  #  s = M7user.start 1
#  {:ok, %__MODULE__{s | cells: c}} end
 {:ok, s} end

  def handle_call(:get, _p, s) do {:reply, s, s} end
  def handle_call(:load, _p, s) do {:reply, s, load(s)} end
  def handle_call(:save, _p, s) do {:reply, s, save(s)} end
  def handle_call({:add_user, u}, _p, s) do {:reply, s.stats.user_counter, add_user(s, u)} end
  def handle_call({:get_user, i}, _p, s) do {:reply, get_user(s, i), s} end
  def handle_call({:create_users, c}, _p, s) do {:reply, create_users(s, c).users, create_users(s, c)} end
  def handle_call(:reset, _p, s) do {:reply, reset(s), reset(s)} end
  def handle_call({:info, u, i}, _p, s) do {:reply, :ok, info(s, u, i)} end
  def handle_call({:put, u, k, v}, _p, s) do {:reply, :ok, put(s, u, k, v)} end
  def handle_call({:puts, k, v}, _p, s) do {:reply, s, puts(s, k, v)} end
  def handle_call({:clra, u}, _p, s) do {:reply, :ok, clra(s, u)} end
  def handle_call({:play}, _p, s) do {:reply, :ok, play(s)} end
  def handle_call({:draw, u, x, y}, _p, s) do {:reply, {x, y}, draw(s, u, x, y)} end

  def i2a(i) do String.to_atom("c#{i}") end

  def rc() do M7state.get.cells |> Enum.random
  |> Map.get(:id) |> M7cell.get end

  def save(s) do
    File.write("../../data/M7"<>to_string(Mix.env), :erlang.term_to_binary s); s end
  def load(s) do case File.read("../../data/M7"<>to_string(Mix.env)) do
    {:ok, f} -> :erlang.binary_to_term f
    _ -> reset(s) end end

    def create_users(s, c) do
    # c = s.stats.user_counter;
      for e <- 1..c, reduce: s do acc ->
         add_user(acc,
         %M7user{name: Faker.Person.name}
         ) end
    end

  def get_user(s, i) do s.users |> Map.fetch :"u#{i}" end

  def check(u, pw), do: :crypto.hash(:sha3_256, pw<>u.pw.s) == u.pw.h

  defp clra(s, u) do

    put_in s.users[:"u#{u}"].board.clra, True
     end

  defp info(s, u, i), do: put_in s.users[:"u#{u}"],
     %M7user{s.users[:"u#{u}"] | info: i}

  defp put(s, u, k, v), do: put_in s.users[:"u#{u}"],
     Map.put(s.users[:"u#{u}"], k, v)
  defp puts(s, k, v), do: Map.put(s, k, v)

  defp draw(s, u, x, y), do:
    put_in s.users[:"u#{u}"].board.pixels,
     Map.put(s.users[:"u#{u}"].board.pixels, x+y*480, u)

def draw(s) do for e <- s, do: draw(2, e.x, e.y) end

def drawline({x0, y0}, {x1, y1}) do
      st = 1 + dst({x0, y0}, {x1, y1})/4 |> floor;
     for e <- 1..st, do: draw(2, floor(x0+(x1-x0)*(e/st)), floor(y0+(y1-y0)*(e/st)))
end

def triw(a, b, c) do
     drawline(a, b); drawline(c, a); drawline(b, c) end

def tri([a, b, c]) do
    for e <- drawline(a, b), do: drawline(e, c) end

def circle({x,y}, r) do
  for e <- 1..r, do:
  draw(2, round(:math.sin(e)*r)+x, round(:math.cos(e)*r)+y)
end

def trans({x, y}, {a,b,c,d,e,f}) do {round(a*x+b*y)+e, round(c*x+d*y)+f} end

# def rot({x, y}, a), do: {x, y}
def move(a, x, y), do: %{a | x: a.x+x, y: a.y+y}

def dst({x0, y0}, {x1, y1}), do: max(abs(x0-x1), abs(y0-y1))
def play(s) do seq = []; s end

# m = %{"amount" => "111.01", "label" => Jason.encode! %{"a" => 2}}
def logymn(m) do GenServer.call :M7state, {:logymn, m} end
def handle_call({:logymn, m}, _p, s) do {:reply, checkymn(m), logymn(s, m)} end
def checkymn(m) do
case m do
  %{
    "amount" => amount,
    "bill_id" => bill_id,
    "codepro" => codepro,
    "currency" => currency,
    "datetime" => datetime,
    "label" => label,
    "notification_type" => notification_type,
    "operation_id" => operation_id,
    "operation_label" => operation_label,
    "sender" => sender,
    "sha1_hash" => sha1_hash,
    "test_notification" => test_notification
  } ->
ns = case File.read "../../data/secret/ymn" do {:ok, ns} -> ns; _ -> "" end
ms =
m["notification_type"]<>"&"<>m["operation_id"]<>"&"<>m["amount"]<>
"&"<>m["currency"]<>"&"<>m["datetime"]<>"&"<>m["sender"]<>"&"<>m["codepro"]<>
"&"<>ns<>"&"<>m["label"];

h =  sha1_hash |> String.upcase()
h2 = :crypto.hash(:sha, ms) |> Base.encode16()
case h == h2
# || test_notification == "true"
 do
  true ->
case Jason.decode(label) do
  {:ok, %{"a" => user}} -> {:to_user, user}
  _ -> :unlabeled
end
  _ -> :compromised
end
_ -> :not_formatted

end

end
defp logymn(s, m) do case checkymn(m) do
  :unlabeled ->
  s = update_in s.inc.ymn, &([m]++&1);
  s = update_in s.b, &((&1 + String.to_float m["amount"]) |> Float.round(2));

  {:to_user, user} ->
  s = update_in s.inc.ymn, &([m]++&1);
  s = update_in s.b, &((&1 + String.to_float m["amount"]) |> Float.round(2));
  update_in s.users[:"u#{user}"].b, &((&1 + String.to_float m["amount"]) |> Float.round(2));
  _ -> s
 end

end

def tick() do GenServer.call :M7state, {:tick} end
def handle_call({:tick}, _p, s) do {:reply, :ok, tick(s)} end
def tick(s) do
  s = update_in s.c, &(&1+1);

 end


def add_user(s, u) do

  s = put_in s.users, Map.put(s.users, :"u#{s.stats.user_counter}",
  %M7user{u |
  twitch: %{name: nil, key: "PogBones MechaRobot " <> Ecto.UUID.generate},
   id: s.stats.user_counter,
   });
        update_in s.stats.user_counter, &(&1 + 1)
       end

def pw(p) do s = :crypto.strong_rand_bytes(8);
  %{h: :crypto.hash(:sha3_256, p<>s), s: s} end

def reset(s), do:
   add_user(%M7state{}, %M7user{name: "a", adm: true, pw:
   case File.read("../../data/secret/adm") do {:ok,p} -> pw(p); _ -> pw(" ") end, vip: true})
   |> add_user(%M7user{name: "an", pw: pw("2"), info: "  "})
   |> add_user(%M7user{name: "artyui", pw: pw("3"), info: "   "})
  # Map.merge %M7state{}, s
  #  |> add_user %M7user{name: "234", pw: 123}

end

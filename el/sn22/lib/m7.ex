
defmodule M7char do
  use GenServer
  # template

  defstruct c: 1, users: %{}

  def start_link(_) do GenServer.start_link __MODULE__, %M4a{}, name: :aa end
  def get() do GenServer.call :aa, :get end

  def init(s) do  inspect s; :timer.kill_after(4444); {:ok, s} end
  def handle_call(:get, _p, s) do {:reply, inspect([s, self]), s} end

  # def sm

end

defmodule M7user do
  use GenServer
  # template

  defstruct c: 1, users: %{}

  def start_link(_) do GenServer.start_link __MODULE__, %M4a{}, name: :aa end
  def get() do GenServer.call :aa, :get end

  def init(s) do  inspect s; :timer.kill_after(4444); {:ok, s} end
  def handle_call(:get, _p, s) do {:reply, inspect([s, self]), s} end

  # def sm

end

defmodule M7cell do
  use GenServer
  # template

  defstruct  [:x, :y, :z, :id, type: 1, hue: 1, wp: %{}]

  def start() do GenServer.start __MODULE__, %M4a{} end
  def start_link(_) do GenServer.start_link __MODULE__, %M4a{}, name: :aa end
  def get() do GenServer.call :aa, :get end

  def init(s) do  :timer.kill_after(4444); {:ok, s} end
  def handle_call(:get, _p, s) do {:reply, inspect([s, self]), s} end


  # def sm

end

defmodule M7box do
  use GenServer
  # template

  defstruct c: 1, users: %{}

  def start_link(_) do GenServer.start_link __MODULE__, %M4a{}, name: :aa end
  def get() do GenServer.call :aa, :get end

  def init(s) do  inspect s; :timer.exit_after(4444, :exit); {:ok, s} end
  def handle_call(:get, _p, s) do {:reply, inspect([s, self]), s} end

  # def sm

end

defmodule M7 do

  def parse do
        m = ["../../data/m7.png", "../../data/m7a.png", "../../data/m7b.png"]
        {_, %{data: d}} = Pixels.read_file Enum.random m

        match = fn
          <<0, 255, 0, 255>> -> "✅"
          <<0, 0, 0, 255>> -> M7cell.start; "⛚"
          <<0, 0, 111, 255>> -> "⛆"
          <<0, 0, 255, 255>> -> "⛽"
          <<0, 111, 0, 255>> -> "☡☭"
          _ -> 0
        end

        d = for <<x::binary-4 <- d>>, do: match.(x); d = Enum.with_index d;
        # d = for <<x::binary-4 <- d>>, x != <<255,255,255,255>>, do: match.(x);
        d |> Enum.reject(fn {x, _} -> x == 0 end) |>
         Enum.map( fn {a, b}->
          %M7cell{type: a, id: b, x: rem(b,64), y: floor((b/64)-1),
           hue: :rand.uniform(24)+b/16} end)

  end
end

defmodule M7state do
  use GenServer
  # template

  defstruct c: 1, s:  %M7cell{}

  def start_link(_) do GenServer.start_link __MODULE__, %M7state{}, name: :aa end
  def get() do GenServer.call :aa, :get end

  def init(s) do  inspect s; :timer.kill_after(4444); {:ok, s} end
  def handle_call(:get, _p, s) do {:reply, inspect([s, self]), s} end

  # def sm

end

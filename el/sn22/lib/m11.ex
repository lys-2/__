

defmodule User do
  use GenServer

  defstruct name: "", id: 1, chars: %{}, chips: 0

  def start(id) do GenServer.start __MODULE__,
   %User{id: id}, name: :"u2#{id}"; end
  def get(id) do GenServer.call :"u2#{id}", :get end

  def init(s) do :timer.exit_after(2000, 1); {:ok, s} end
  def handle_call(:get, _p, s) do {:reply, s, s} end

end

defmodule Cell do
  use GenServer

  defstruct name: "", wp: [], id: 1

  def start(id) do GenServer.start __MODULE__,
   %Cell{id: id, name: Faker.Pokemon.location}, name: :"cl#{id}"; end
  def get(id) do GenServer.call :"cl#{id}", :get end

  def init(s) do  :timer.exit_after(2000, 1); {:ok, s} end
  def handle_call(:get, _p, s) do {:reply, s, s} end

end

defmodule Char do
  use GenServer

  defstruct name: 1, lvl: 1, id: 1, cell: 1

  def start(id) do GenServer.start __MODULE__,
   %Char{id: id, name: Faker.Superhero.name}, name: :"ch#{id}"; end
  def get(id) do GenServer.call :"ch#{id}", :get end

  def init(s) do  :timer.exit_after(2000, 1); {:ok, s} end
  def handle_call(:get, _p, s) do {:reply, s, s} end

end

defmodule Tree do
  defstruct id: 1, type: "", grow: 1, cell: 1, path: [1], trunk: false

  def break tree do %Tree{tree | trunk: true} end
  def grow tree do %Tree{tree | grow: tree.grow+1} end
  def move tree, cell do %Tree{tree | cell: cell} end

end

defmodule State do
  defstruct users: %{}, chars: %{}, cells: %{}, uc: 1, chc: 1, cec: 1

  def start() do GenServer.start __MODULE__, %State{}, name: :state; end
  def get() do GenServer.call :state, :get end
  def gather() do GenServer.call :state, :gather end
  def init(s) do :timer.exit_after(2000, 1);
  s = for e <- 1..11, reduce: s do s -> User.start s.uc;
   s = put_in s.uc, s.uc+1; end

  s = for e <- 1..11, reduce: s do s -> Char.start s.chc;
   s = put_in s.chc, s.chc+1; end

  s = for e <- 1..11, reduce: s do s -> Cell.start s.cec;
   s = put_in s.cec, s.cec+1; end

   {:ok, s}  end

  def handle_call(:get, _p, s) do {:reply, s, s} end
  def handle_call(:gather, _p, s) do {:reply, gather(s), gather(s)} end

  def gather(s) do s = for e <- 1..11, reduce: s do s ->
    s = put_in s.users, Map.put(s.users, e, User.get e);
    s = put_in s.cells, Map.put(s.cells, e, Cell.get e);
    s = put_in s.chars, Map.put(s.chars, e, Char.get e);
  end
   end

end

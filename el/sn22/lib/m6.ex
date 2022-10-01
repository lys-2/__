defmodule Sn22Web.ThermostatLive do
  # In Phoenix v1.6+ apps, the line below should be: use MyAppWeb, :live_view
  use Sn22Web, :live_view

  def render(assigns) do
    ~H"""
    Current temperature: <%= @tem.m %>
    <p> a <%= @tem.s %> </p>

    """
  end

  def mount(_params, %{}, socket) do
  if connected?(socket), do: Process.send_after(self(), :update, 12);
  {:ok, assign(socket, :tem, %{m: 1, s: M5.get})}

  end

  def handle_info(:update, socket) do
    Process.send_after(self(), :update, 12)

    {:noreply, assign(socket, :tem, %{m: (M6.start; M6.get), s: M5.get})}
  end
end

defmodule M6 do
  use GenServer

  defstruct a: 0, h: 256, w: 256, m: 8, p: :persistent_term, s: nil

  def start() do GenServer.start __MODULE__, %M6{}, name: :cls; end
  def pause() do 1 end
  def res() do stop; start; end
  def stop() do GenServer.stop :cls; end

  def get() do GenServer.call :cls, :get end
  def handle_call(:get, _p, s) do {:reply, get(s), s} end

  def init(s) do

    s = %M6{s | a: :atomics.new(s.m, [])};

    :timer.exit_after(100, 1)
    # :timer.apply_after(4000, GenServer, :stop, [self])
    s = %M6{s | s: fill(s.a, s.m)}

     {:ok, s} end

  def fill(a, m) do
    %M6{s: for e <- 1..m do :atomics.put a, e, r =
      Enum.random([0,0,0,0,0,0,0,0,3,3,3,1,2,0,0]); r; end};
        #  |> IO.puts
  end

  def get(s) do for e <- 1..s.m do :atomics.get s.a, e;
    elem {"⛆","⚽","⚾","▦"}, :atomics.get(s.a, e)
        end end


  # def handle_call(:get, _p, s) do {:reply, draw(s.st), s} end
  # def handle_call(:gets, _p, s) do {:reply, s, s} end
  # def handle_info(:tick, s) do {:noreply, tick s} end



end

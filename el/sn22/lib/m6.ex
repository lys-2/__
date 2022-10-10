
defmodule M6 do
  use GenServer

  defstruct a: 0, h: 256, w: 256, m: 8, p: :persistent_term, s: nil

  def start() do GenServer.start __MODULE__, %M6{}, name: :cls; end
  def pause() do 1 end
  def res() do stop; start; end
  def stop() do GenServer.stop :cls; end

  def get() do GenServer.call :cls, :get end
  def handle_call(:get, _p, s) do {:reply, get(s), s} end
  def handle_info(:set, s) do {:noreply, set(s)} end

  def init(s) do

    s = %M6{s | a: :atomics.new(s.m, [])};

    # :timer.exit_after(100, 1)
    :timer.send_interval(250, self, :set)
    s = %M6{s | s: set(s)}

     {:ok, s} end

  def set(s) do
    %M6{s | s: for e <- 1..s.m do :atomics.put s.a, e, r =
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

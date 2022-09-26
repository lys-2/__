defmodule M6 do
  use GenServer

  def start() do GenServer.start __MODULE__, 0, name: :cls; end
  def pause() do 1 end
  def res() do stop; start; end
  def stop() do GenServer.stop :cls; end

  def init(s) do

    h = 240; w = 135*256; hw = h*w;
    a = :atomics.new(h*w, []);
    fill a, h, w;

    :timer.exit_after(10, 1)

     {:ok, a} end

  def fill(a, h, w) do
      for e <- 1..h*w do
      :atomics.put a, e, Enum.random([0,0,0,0,0,0,0,0,3,3,3,1,2,0,0]);
       elem {"⛆","⚽","⚾","▦"}, :atomics.get(a, e)  end
         |> IO.puts
  end



  # def handle_call(:get, _p, s) do {:reply, draw(s.st), s} end
  # def handle_call(:gets, _p, s) do {:reply, s, s} end
  # def handle_info(:tick, s) do {:noreply, tick s} end



end

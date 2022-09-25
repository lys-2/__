defmodule M5 do
  use GenServer

  defstruct tr: 1611, st: 0, tm: nil

  def start() do GenServer.start __MODULE__, %M5{st: 0}, name: :seq; end
  def pause() do 1 end
  def res() do stop; start; end
  def stop() do GenServer.stop :seq; end
  def get() do GenServer.call :seq, :get end
  def gets() do GenServer.call :seq, :gets end
  def set(tr) do send Process.whereis(:seq), {:tr, tr}; end


  def init(s) do

    # tick s; IO.puts s;
    # send(self, :tick)
    # :timer.send_after(1, :tick);

    {_, t} = :timer.send_interval(s.tr, :tick);

    # :timer.apply_after(4000, GenServer, :stop, [self])
    # tick2 1
    {:ok, %M5{s | tm: t}}
  end

  def handle_call(:get, _p, s) do {:reply, draw(s.st), s} end
  def handle_call(:gets, _p, s) do {:reply, s, s} end
  def handle_info(:tick, s) do {:noreply, tick s} end
  def handle_info({:tr, tr}, s) do {:noreply, %M5{s | tr: tr}} end

  # def handle_info(:tick2, s) do {:noreply, tick2 s} end

  def tick(s) do
    IO.puts (inspect(s) <> draw(s.st));
    s = %M5{s | tm: set_tr(s.tm, s.tr)}
    case rem(s.st, 4) do
      # 3 ->  %M5{s | st: s.st-3};
      3 ->  %M5{s | st: s.st-3};
      # 4 -> IO.puts(inspect(s)<> "  !23423424"); {s+1, t}
      # 8 -> IO.puts(inspect(s)<> "  !"); {s+1, t}
      _ ->  %M5{s | st: s.st+1}

     end
  end

  defp set_tr(tm, tr) do

    :timer.cancel(tm);
    {:ok, t} = :timer.send_interval(tr, :tick); t

  end

  def draw(s) do case s do
        0 -> "🟧🟩🟩🟩"
        1 -> "🟩🟧🟩🟩"
        2 -> "🟩🟩🟧🟩"
        3 -> "🟩🟩🟩🟧"
        _ -> "🟩🟩🟩🟩"
        end
      end

  # def tick2(s) do
  #   case {s, rem(s, 1_000_000)} do
  #    {9_000_000, _} -> IO.puts(inspect {Time.utc_now(), 1, s});
  #    {_, 0} -> tick2(s+1)
  #    _ -> tick2(s+1)
  #   end
  # end

end

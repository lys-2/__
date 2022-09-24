defmodule M5 do
  use GenServer

  def start(s) do GenServer.start __MODULE__, 0, name: :seq end
  def get() do GenServer.call :seq, :get end

  def init(s) do
B
    # tick s; IO.puts s;
    # send(self, :tick)
    # :timer.send_after(1, :tick);

    {_, t} = :timer.send_interval(250, :tick);
    # :timer.apply_after(4000, GenServer, :stop, [self])
    # tick2 1
    IO.puts("We start")
    {:ok, {s, t}}
  end

  def handle_call(:get, _p, {s,t}) do {:reply, draw(s), {s,t}} end
  def handle_info(:tick, s) do {:noreply, tick s} end
  # def handle_info(:tick2, s) do {:noreply, tick2 s} end

  def tick({s, t}) do case rem(s, 4) do

      3 ->  {s+1-4, t}
      # 4 -> IO.puts(inspect(s)<> "  !23423424"); {s+1, t}
      # 8 -> IO.puts(inspect(s)<> "  !"); {s+1, t}
      _ ->  {s+1, t}

     end
  end

  def draw(s) do case s do
        0 -> "🟧🟩🟩🟩"
        1 -> "🟩🟧🟩🟩"
        2 -> "🟩🟩🟧🟩"
        3 -> "🟩🟩🟩🟧"
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

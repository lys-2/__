defmodule M1 do
  require Logger

  def api(port) do
    {ok, s} = :gen_udp.open(port, [:binary, active: true]);

    api_r(s);

  end

  def api_r(s) do
    receive do m -> Logger.alert inspect m; api_r(s) end
  end

  def ac(s) do

      spawn M1, :i, [self];

      run_ac(s);
  end

  def init do

    spawn M1, :api, [11113]; spawn M1, :api, [11114];


    st = %{
      users: {},
       time: 0,
        tick: 0
      }

    for id <- 1..12 do

      s = %{
        id: id,
        name: nil,
        timer: 0,
        likes: [],
         devices: [],
          sessions: []
        }

      spawn M1, :ac, [s];

     end

     run_main(st);

  end

  def run_main(st) do receive do {p, "gs"} -> send(p, st); run_main(st) end end

  def i(s) do Process.send_after(s,
    :rand.uniform(255), :rand.uniform(2000));
    Process.sleep 3000; i s; end

  def run_ac(s) do

    receive do
      1 ->
        #  Logger.warn "lk  "<>inspect(s)<>String.duplicate("|", lk+1);
        run_ac(Map.put s, :timer, s[:timer] + 1)
      2 -> IO.inspect "ds  "; run_ac(s)
      3 -> Logger.debug "st  "; run_ac(s)
      4 -> IO.inspect "st m  "; run_ac(s)
      6 -> Logger.warn "im done! "<>inspect(s); Process.exit self, 1
      _ -> nil; run_ac(s)

   end
  end
end

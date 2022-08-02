defmodule Sn22 do
  @moduledoc """
  Sn22 keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  def run do
      receive do
        {:hi, name} ->
          IO.puts "Hi, #{name}"
      # {:d, d} -> send(d, Process.get())
      end

    end



    def run2(st, {msg, mc, rc}) do
        if Process.whereis(:tw) do Process.unregister(:tw) end

    Process.register(self(), :tw)
    Process.put(:m, msg)
    Process.put(:mc, mc)
    Process.put(:rc, rc) # request count

    {:ok, s} = :gen_tcp.connect('irc.chat.twitch.tv', 6667, [:binary])
    tt = ["/home/sn/sx/tw", "/home/sn22/sx/tw"]
    for e <- tt do
      case File.read(e) do
      {:ok, t} -> :gen_tcp.send(s, "PASS " <>  t)
      _ -> nil
        end
          end

    chs = ["sunraylmtd", "peregonstream", "sn_b0t", "restiafps", "228hooligan",
     "weekoftheagents", "chaipei", "screamlark", "raymarch", "dustoevsky", "gdesecrate", "gamesdonequick"]

    chsm = for e <- chs, do: "#"<>e

    chsm = "JOIN "<>Enum.join(chsm, ",") <> "\r\n"
    #  |> IO.inspect

    :gen_tcp.send(s, 'NICK sn_b0t\r\n')
    :gen_tcp.send(s, chsm)

     rl(s)


    end

    defp mp(m) do
      # IO.puts 1;
      if m =~ "PRIVMSG #" do

      ch =  String.split(m, "PRIVMSG #") |> Enum.at(1) |>
        String.split(" :") |> Enum.at(0);

      n =  String.split(m, ":") |> Enum.at(1) |>
       String.split("!") |> Enum.at(0);

      m =  String.split(m, " :") |> Enum.at(1) |>
      String.split("\r\n") |> Enum.at(0);

      Process.put(:m, [mt =
        {id = Process.put(:mc, Process.get(:mc)+1),
         :calendar.universal_time, ch, n, m} | Process.get(:m)]);
         IO.inspect mt;
         Sn22Web.Endpoint.broadcast!("room:lobby", "new_msg", %{body:
         Phoenix.View.render_to_string(Sn22Web.PageView, "T1.html",
          %{list: [id, n, ch, m]})
         })
      end
    end

    defp rl(s) do
      receive do
        {:tcp, _, "PING :tmi.twitch.tv\r\n"} -> :gen_tcp.send(s,
         'PONG :tmi.twitch.tv\r\n') |> IO.inspect; rl(s);

        {:tcp_closed, _} -> spawn(Sn22, :run2,
         [s, {Process.get(:m), Process.get(:mc), Process.get(:rc)}]);
         Process.exit(self(), "1")

        # {_,_,m} -> String.split(m, "\#") |> IO.inspect |> Process.put(:m)
        {p, 1} -> send(p, Process.get(:m) |> Enum.at(0)); rl(s)
        {p, "rc"} -> send(p, Process.put(:rc, Process.get(:rc)+1)); rl(s)
        {_,_,m} -> mp(m);

         rl(s)

        # fn m ->

        #   IO.inspect m end; m



     end


    end

end

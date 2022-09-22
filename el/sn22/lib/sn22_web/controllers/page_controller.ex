defmodule Sn22Web.PageController do
  use Sn22Web, :controller
  alias Phoenix.LiveView

  def index(conn, _params) do
    # send(Process.whereis(:tw), {self(), 1})
    render(conn, "index.html")
  end

  def gd(conn, _params) do
    # send(Process.whereis(:tw), {self(), 1})
    render(conn, "gd.html")
  end

  def sm(conn, _params) do
    # send(Process.whereis(:tw), {self(), 1})
    a = 1
    render(conn, "sm.html")
  end

  def rq(conn, _params) do
    # send(Process.whereis(:tw), {self(), 1})
    text(conn, inspect conn.params["time"]
     )
  end

  def rq1(conn, _params) do
    # send(Process.whereis(:tw), {self(), 1})
    text(conn, M2.get
     )
  end

  def p(conn, _params) do
    if conn.params["say"] |> String.length > 99 do text(conn, "message too long")
    else
      if Process.whereis(:mb) |> Process.info(:messages) |> elem(1) |> length > 49 do
      Process.whereis(:mb) |> Process.exit(1);
      Process.unregister(:mb);
      spawn(Sn22, :run, []) |> Process.register(:mb)
      end
      Process.whereis(:mb) |> send(conn.params["say"])
      redirect(conn, to: "/")
  end

  end
end

defmodule Sn22Web.PageController do
  use Sn22Web, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end

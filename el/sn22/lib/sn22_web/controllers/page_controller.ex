defmodule Sn22Web.PageController do
  use Sn22Web, :controller

  def index(conn, _params) do
    text(conn, "11111")
  end
end

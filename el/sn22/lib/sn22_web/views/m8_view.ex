
defmodule Sn22Web.V2 do
  alias Sn22Web.Presence
  use Sn22Web, :live_view

  def mount(p, %{"user" => user}, socket) do
    if connected?(socket), do:
    :timer.send_interval(1000, :update)

  {:ok, u} = M7state.get_user(user)

    updated =
      socket
      |> assign(:user, u.name)
      |> assign(:uid, u.id)

      # |> assign(:x, session)
    {:ok, updated}
  end



  def render(assigns) do
    ~H"""
<style> body {
background-color: <%= "darkblue" %>;
font-size: 36px;
} </style>

    <%= inspect Store.init %>
    """
  end
end

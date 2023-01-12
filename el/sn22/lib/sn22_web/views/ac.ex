
defmodule Sn22Web.Ac do
  alias Sn22Web.Presence
  use Sn22Web, :live_view
  alias Phoenix.Socket.Broadcast

  def mount(p, %{"user" => user}, socket) do
    if connected?(socket), do:

    Phoenix.PubSub.subscribe(Sn22.PubSub, "ac")
    {:ok, u} = M7state.get_user(user);
    :timer.send_interval(25, {:update, u})

    updated =
      socket
      |> assign(:acc, M7state.get.inc.ymn)
      |> assign(:ex, u.ex)
      |> assign(:label, Jason.encode! %{"a" => user})
      |> assign(:us, M7state.get.users)
      |> assign(:b, M7state.get.b)
      |> assign(:c, M7state.get.c)
      |> assign(:chips, M7state.get.chips)
      |> assign(:ua, u.a)
      |> assign(:ub, u.b)

    {:ok, updated}
  end

  def handle_info({:update, u}, socket) do

    {:noreply, socket
    |> assign(:acc, M7state.get.inc.ymn)
    |> assign(:chips, M7state.get.chips)

    |> assign(:b, M7state.get.b)
    |> assign(:us, M7state.get.users)
    |> assign(:c, M7state.get.c)
    |> assign(:ex, u.ex)


  }
  end

  def render(assigns) do
    ~H"""
        <%= (inspect @c)%>
<br>
    <%= ( :erlang.float_to_binary(@b, [decimals: 2])) <>" p"%>

    <br>

<%= for {k,v} <- @ex do %>
  <span class="name"><%= "#{k}, #{v}__" %></span>
<% end %>

<br>
<form method="POST" action="https://yoomoney.ru/quickpay/confirm.xml">
    <input type="hidden" name="receiver" value="4100117845246172"/>
    <input type="hidden" name="label" value="1111"/>
    <input type="hidden" name="quickpay-form" value="button"/>
    <input placeholder="...0 p" name="sum" value={""} type='number' min="1" max="99999" step="0.01"/>
    <%!-- <label><input type="radio" name="paymentType" value="PC"/>ЮMoney</label>
    <label><input type="radio" name="paymentType" value="AC"/>Банковской картой</label> --%>
    <%!-- <input  type="submit" disabled="true" value="пк"/> --%>
    <input  type="submit"  value="пк"/>
</form>

<%= for {k,v} <- @us do %>
  <span class="name"><%= "#{v.id}, #{v.a}, #{v.b}__" %></span>
<% end %>

  <%= for m <- @acc do %>
  <div class="name"><%= inspect m %></div>
<% end %>
<br>
    <%= (inspect @chips) <>""%>
    """
  end
end

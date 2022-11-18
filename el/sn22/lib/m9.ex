defmodule Shopper do
  defstruct name: "", inv: [], cr: 100

end

defmodule Store do
  defstruct store: %{}, log: %{}, lc: 1
  def init, do: %Store{
    store:
   %{
    1 => %Shopper{name: "Alice", inv: ["🍎", "🍏", "🍏"]},
    2 => %Shopper{name: "Bob"},
    3 => %Shopper{inv: [3, 2, 3, 1]}
  },
  log:
  %{
   1 => "We started"

 },
 lc: 2
}

  def log(s, m) do
   s = put_in(s.log, Map.put(s.log, s.lc, m)
   );
   s = put_in(s.lc, s.lc+1)
  end

  def bar2 do
    acc = 1
    inv = [1,2,3,4,5,4,3]
    l = [2,2,2]
    for e <-  1..11, do: acc = e + acc
    Enum.reduce()

  end

  def bar(s, a, b, i, i2) do case check(s, a, b, i) and check(s, b, a, i2) do
    true -> s = give(s, a, b, i); s = give(s, b, a, i2)
    false -> s
  end
 end


 def check(inv, i) do 1 end

  def check(inv, i) do case i in inv do
    true -> :ok
    false -> :not_there
  end end

  def check(s, a, b, i) do
   case Enum.member?(s.store[a].inv, i) do
    true -> true
    false -> IO.puts "#{s.store[a].name} has no #{i}"; false
   end
   end
  def give(s, a, b, i) do

    sa = s.store[a]
    sb = s.store[b]

    case check(s, a, b, i) do
    true ->
       m = "#{sa.name} gives #{i} to #{sb.name} "
      s = log(s,m)
      s = put_in(s.store[a].inv, List.delete(sa.inv, i));
      s = put_in(s.store[b].inv, [i | s.store[b].inv]);
    false ->
      s
    end
    end

    def check(s, a, b, :cr, c) do s.store[a].cr >= c end

    def give(s, a, b, :cr, c) do
      sa = s.store[a]
      sb = s.store[b]

      case check(s, a, b, :cr, c) do
      true ->
         m = "#{sa.name} gives #{c} :cr to #{sb.name} "
        s = log(s,m)
        s = put_in(s.store[a].cr, s.store[a].cr - c);
        s = put_in(s.store[b].cr, s.store[b].cr + c);
      false ->
        IO.puts "#{sa.name} has no #{c} :cr"
        s
      end end
   end

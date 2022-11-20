defmodule Shopper do
  defstruct name: "", inv: [], avt: "🔩🪆",
   gear: %{sh: "🥾", lb: "👖", rh: "🏸", lh: "🔫", b: "👕"}, lc: :ms, gg: 100,
   ac: [:invest, :talk, :touch, :go]
end

defmodule Store do
  defstruct store: %{}, log: %{}, lc: 1, map: %{}
  def init, do: %Store{
    map: %{
      ms: %{wp: [:st, :field, :up, :slm, :chr, :park], ent: [1,2,3]},
      st: %{wp: [:ms], ent: [4]},
      chr: [:ms],
      field: [:ms, :woods],
      woods: [:field],
      up: %{wp: [:ms, :park], ent: [5]},
      slm: [:ms, :sew],
      sew: %{wp: [:slum, :sew2], ent: [6]},
      sew2: [:sew],
      park: [:up]
    },
    store:
   %{
    1 => %Shopper{name: "Alice", inv: ["🍎", "🍏", "🍏"]},
    2 => %Shopper{name: "Bob", inv: ["🍎","🍎","🍎", "🍏", "🍏", "🧢"]},
    3 => %Shopper{name: "box" ,inv: [3, 2, 3, 1]},
    4 => %Shopper{name: "box" ,inv: [3, 2, 3, 1]},
    5 => %Shopper{name: "box", inv: [3, 2, 3, 1]}
  },
  log:
  %{
   1 => "We started"

 },
 lc: 2
}

def floors(m, c) do

  add = fn(m, lc) -> Map.put m, lc, %{wp: []} end
  route = fn m, a, b -> put_in m[a].wp, m[a].wp ++ [b] end
  # add.(m, :"floor#{0}")
  for e <- 1..c, reduce: m do m ->
    # |> add.(:"floor#{e+1}")
    m = add.(m, :"floor#{e}")
    m = route.(m, :"floor#{e}", :"floor#{e+1}")
    m = route.(m, :"floor#{e}", :"floor#{e-1}")
    # m = add.(m, :"floor#{e+1}")
    # |> route.(:"floor#{e}", :"floor#{e-1}")
  end
end


  def log(s, m) do
   s = put_in(s.log, Map.put(s.log, s.lc, m)
   );
   s = put_in(s.lc, s.lc+1)
  end


  def bar(s, a, b, i, i2) do case check(s, a, b, i) and check(s, b, a, i2) do
    true -> s = give(s, a, b, i); s = give(s, b, a, i2)
    false -> s
  end
end

def bar(a,b) do case ck(a, b) do
  {:ok, df, inv} -> inv
  {:no, df, inv} -> {:no, df, inv}
end end

def eq(inv, i, gear, slot), do: {:ok, inv, gear}

def ck({inv, acc}) do if acc == [] do
   {:ok, acc, inv} else {:no, acc, inv} end end
def ck(inv, list) do ck(inv, list, []) end
def ck([], list, acc) do ck{[], list ++ acc} end
def ck(inv, [], acc) do ck{inv, acc} end
def ck(inv, [i | l], acc) do
  inv2 = List.delete inv, i
  case i in inv do
    true -> ck(inv2, l, acc)
    false -> ck(inv2, l, [i | acc])
  end
   end



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

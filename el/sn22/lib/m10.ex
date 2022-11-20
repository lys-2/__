defmodule Ms do

  defstruct users: [:adm, :user],
  frame: 0,
   log: [a: [1], b: [2]],
    chips: [1,2,3,4,5]

  def play s do for e <- (Enum.reverse s.log), reduce: s do s ->
     {f,a} = e; s = apply :"Elixir.Ms",f,[s] ++ a;
    s = put_in s.frame, s.frame+1;
    [h|t] = s.log; s = put_in s.log, t;
    end end

  def a s, a do put_in(s.chips, [a] ++ s.chips) end
  def a s, a, :l do a |> log :a, [a] end

  def b s, a do put_in s.chips, s.chips -- [a] end
  def log s, f, a do put_in s.log, [{f, [a]}]++s.log end

  def run s, f, [a] do apply(:"Elixir.Ms",f,[s, a]) |> log f, a end

  def gen s do for e <- 1..11, reduce: s do s -> run(s, :a, [1]) end end

end

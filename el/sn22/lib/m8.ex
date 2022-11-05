defmodule M8 do
  import Nx.Defn

    def t() do import Nx

    size = 128; s1 = (size*2) - 1;
    s2 = size*size*3
    {_,t2,t1} = :os.timestamp; t1 = t2/50000 + t1/10000

    t3 = iota({s2}) |> divide(tensor(33))

    t2 = random_uniform({s2})
    |> multiply(t3)
    |> add(tensor(1))
    |> multiply(cos divide(tensor(t1), 1000))
    # |> Nx.round
    |> as_type(:u8)

    match = fn
      1 -> 34
      2 -> 121
      3 -> 124
      4 -> 112
      _ -> 32
    end

    l = t2 |> to_flat_list
    l = for e <- l, do: match.(e)
    t = for {e, c} <- Enum.with_index(l),
     into: "" do case rem(c, size*2) do
      ^s1 -> <<e>><><<10>>
      _ -> <<e>>
    end end

  end

  def run do
    target_m = :rand.normal(0.0, 10.0)
    target_b = :rand.normal(0.0, 5.0)

target_fn = fn x -> target_m * x + target_b end

data =
  Stream.repeatedly(fn -> for _ <- 1..32, do: :rand.uniform() * 10 end)
  |> Stream.map(fn x -> Enum.zip(x, Enum.map(x, target_fn)) end)
  IO.puts("Target m: #{target_m}\tTarget b: #{target_b}\n")
  {m, b} = train(100, data)
  IO.puts("Learned m: #{Nx.to_number(m)}\tLearned b: #{Nx.to_number(b)}")

  end

  defn predict({m, b}, x) do
    m * x + b
  end
  defn loss(params, x, y) do
    y_pred = predict(params, x)
    Nx.mean(Nx.power(y - y_pred, 2))
  end
  defn update({m, b} = params, inp, tar) do
    {grad_m, grad_b} = grad(params, &loss(&1, inp, tar))
    {
      m - grad_m * 0.01,
      b - grad_b * 0.01
    }
  end
  defn init_random_params do
    m = Nx.random_normal({}, 0.0, 0.1)
    b = Nx.random_normal({}, 0.0, 0.1)
    {m, b}
  end

  def train(epochs, data) do
    init_params = init_random_params()
    for _ <- 1..epochs, reduce: init_params do
      acc ->
        data
        |> Enum.take(200)
        |> Enum.reduce(
          acc,
          fn batch, cur_params ->
            {inp, tar} = Enum.unzip(batch)
            x = Nx.tensor(inp)
            y = Nx.tensor(tar)
            update(cur_params, x, y)
          end
        )
    end
  end
end

defmodule M8s do
  import Nx.Defn

  def p(), do: 8888

  defn f(x) do
    Nx.exp x
  end

  defn b(x) do
    grad(&f/1).(x)

  end

  def a(f), do:
  Nx.iota({222}, type: :f32)
  |> c
  |> Nx.to_flat_list
  |> Enum.map(fn x -> Float.round(x, 2) end)

  defn c(a) do import Nx
    # sin(e*(e/128/5)+e/11
    v = 1
    v2 = ceil cos(a/2048*16)
    v1 = ceil cos a/2048
    v3 = sin(a/16)/16
    f = &sin(&1*&1*2048)

    sin(a*(a/1111111)+a)
    # |> multiply(v)
    |> multiply(v*v2*v1)
    # |> f.()
    |> divide(16)
    # sin(a*(a/128/5))+a/16

  end

end

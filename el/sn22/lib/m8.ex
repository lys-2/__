defmodule M8 do
  import Nx.Defn

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

  def p(), do: 4444

  def a(f), do:
  Enum.to_list(1..4444) |> Nx.tensor(type: :u16)
  |> c
  |> Nx.to_flat_list
  |> Enum.map(fn x -> Float.round(x, 2) end)

  defn c(a) do import Nx
    # sin(e*(e/128/5)+e/11
    v = 1
    v2 = ceil cos(a/2222*128)
    v1 = ceil cos a/222
    f = &sin(&1*&1*11111)

    sin(a*(a/1111111)+a)
    |> multiply v
    # |> multiply v*v2*v1
    # |> f.()
    |> divide(18)
    # sin(a*(a/128/5))+a/16

  end

end

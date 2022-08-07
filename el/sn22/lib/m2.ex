defmodule M2 do
  use Agent

  def start_link(_opts) do

    init()

    Agent.start_link(fn -> nil end, name: __MODULE__);


  end

  def init() do

  t = :timer.apply_interval(:timer.seconds(4), M2, :update, []);

  Registry.start_link(keys: :unique, name: MyAgents);

  1..123
    |> Enum.map(fn i -> Agent.start_link(fn -> :rand.uniform(16*64) end,
     name: {:via, Registry, {MyAgents, i}}) end)



 end

  def apply_env(env) do 1 end

  def get() do
    1..123 |>
    Enum.map(fn i ->
      Agent.get({:via, Registry, {MyAgents, i}}, & &1)
    end) |> inspect limit: 999999
  end


  def get2(get) do
    for e <- 0..64*16 do 1 end
    |> inspect limit: 999999
  end

  def update() do

  # System.cmd("mix", ["assets.deploy"]);

   s = 1..123 |>
    Enum.map(fn i ->
      Agent.update({:via, Registry, {MyAgents, i}},
       fn _ -> :rand.uniform(64*16) end);
   Agent.update(M2, fn s -> s end)

    end)
end

end

defmodule M3 do
  use Agent


  def start_link(_opts) do
    Agent.start_link(fn -> String.duplicate(".", 64*16) end, name: __MODULE__);

  end

  def get() do
    Agent.get(__MODULE__, & &1)
  end

end

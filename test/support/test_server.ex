defmodule Jex.TestServer do
  @moduledoc false

  use Agent

  def start_link(_opts) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def replace(target, override) do
    Agent.update(__MODULE__, &Map.put(&1, target, override))
  end

  def fetch(target) do
    Agent.get(__MODULE__, &Map.fetch(&1, target))
  end
end

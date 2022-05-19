defmodule Jex.Example.ModUsingInjector do
  use Jex.Injector do
    alias Jex.Example.BasicDep, as: Dep
    alias Jex.Example.DepWithBehaviour
  end

  def basic_dep(), do: Dep.identify()
  def dep_with_behaviour(), do: DepWithBehaviour.identify()
end

defmodule Jex.Example.ModToMox do
  use Jex.Injector do
    resolve_with Jex.Mox
    alias Jex.Example.DepWithBehaviour
  end

  def dep(), do: DepWithBehaviour.identify()
end

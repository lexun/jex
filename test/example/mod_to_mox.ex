defmodule Jex.Example.ModToMox do
  @moduledoc false

  use Jex.Injector do
    resolve_with Jex.Mox
    alias Jex.Example.DepWithBehaviour
  end

  def dep(), do: DepWithBehaviour.identify()
end

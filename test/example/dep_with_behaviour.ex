defmodule Jex.Example.DepWithBehaviour do
  use Jex.GenerateBehaviour

  @spec identify :: String.t()
  def identify() do
    "DepWithBehaviour"
  end
end

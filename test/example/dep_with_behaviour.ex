defmodule Jex.Example.DepWithBehaviour do
  @moduledoc false

  use Jex.GenerateBehaviour

  @spec identify :: String.t()
  def identify() do
    "DepWithBehaviour"
  end
end

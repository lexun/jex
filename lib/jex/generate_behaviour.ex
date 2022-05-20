defmodule Jex.GenerateBehaviour do
  @moduledoc """
  Turns the current module into a behaviour based on the specs of publicly
  defined functions.

  This is useful in cases where you only have one implementation, but want to
  use mox to create a mock that you can resolve to in your test environment.

  ## Example

      defmodule Greeter do
        use Jex.GenerateBehaviour

        @spec hello :: String.t()
        def hello(), do: "Hello!"
      end

      Mox.defmock(GreeterMock, for: Greeter)
  """

  defmacro __using__(_opts) do
    quote do
      @before_compile unquote(__MODULE__)
    end
  end

  defmacro __before_compile__(env) do
    env.module
    |> Module.definitions_in(:def)
    |> Enum.map(&Module.spec_to_callback(env.module, &1))
  end
end

defmodule Jex.GenerateBehaviour do
  @moduledoc """
  Turns the current module into a behaviour.
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

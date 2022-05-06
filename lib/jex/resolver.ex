defmodule Jex.Resolver do
  @callback resolve(atom) :: atom
  defmacro __using__(_opts) do
    quote do
      @behaviour unquote(__MODULE__)
      def resolve(target), do: target
      defoverridable resolve: 1
    end
  end
end

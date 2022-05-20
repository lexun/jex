defmodule Jex.Resolver do
  @moduledoc """
  The resolver behaviour and default implementation.

  ## Example

      defmodule MyApp.MockResolver do
        use Jex.Resolver

        @mocks %{
          Greeter => GreeterMock,
          Cart => CartMock
        }

        for {target, mock} <- @mocks do
          Mox.defmock(mock, for: target)
        end

        @impl Jex.Resolver
        def resolve(target), do: @mocks[target] || target
      end
  """

  @doc """
  Determines what module should be injected into a caller.

  Recieves the module that was the original target of an alias and should return
  another module that implements the same interface.
  """
  @callback resolve(atom) :: atom

  defmacro __using__(_opts) do
    quote do
      @behaviour unquote(__MODULE__)
      def resolve(target), do: target
      defoverridable resolve: 1
    end
  end

  @doc """
  The default behaviour simply resolves to the original target of the alias.
  """
  @spec resolve(atom) :: atom
  def resolve(target), do: target
end

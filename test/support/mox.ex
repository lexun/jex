defmodule Jex.Mox do
  @moduledoc false

  use Jex.Resolver
  require Mox

  @impl Jex.Resolver
  def resolve(target) do
    create_mocks(target)
    Jex.Mox.mock_for(target)
  end

  def create_mocks(modules) when is_list(modules) do
    Enum.map(modules, &create_mocks/1)
  end

  def create_mocks(module) when is_atom(module) do
    mock = mock_for(module)

    unless already_defined?(mock) do
      Mox.defmock(mock, for: module)
    end

    :ok
  end

  def mock_for(module) do
    String.to_atom(to_string(module) <> "Mock")
  end

  defp already_defined?(mock) do
    :erlang.function_exported(mock, :module_info, 0)
  end
end

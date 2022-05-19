defmodule Jex.AppConfigTest do
  use ExUnit.Case, async: false

  @compile {:no_warn_undefined, {Jex.AppConfigTest.Default, :call, 0}}
  @compile {:no_warn_undefined, {Jex.AppConfigTest.MockedDeps, :call, 0}}

  @module_code """
    use Jex.Injector do
      alias Jex.Example.DepWithBehaviour, as: Dep
    end

    def call(), do: Dep.identify()
  """

  setup do
    on_exit(fn ->
      Application.put_env(:jex, :resolver, nil)
    end)
  end

  test "uses Jex.Resolver by default" do
    refute Application.get_env(:jex, :resolver)
    create_module(Jex.AppConfigTest.Default)
    assert Jex.AppConfigTest.Default.call() == "DepWithBehaviour"
  end

  test "default resolver can be set in config and is used at compile time" do
    Jex.Example.DepWithBehaviour
    |> Jex.Mox.mock_for()
    |> Mox.stub(:identify, fn -> "Mock" end)

    Application.put_env(:jex, :resolver, Jex.Mox)
    create_module(Jex.AppConfigTest.MockedDeps)

    # No effect since already compiled
    Application.put_env(:jex, :resolver, Jex.Resolver)

    assert Jex.AppConfigTest.MockedDeps.call() == "Mock"
  end

  defp create_module(name) do
    ast = Code.string_to_quoted!(@module_code)
    Module.create(name, ast, __ENV__)
  end
end

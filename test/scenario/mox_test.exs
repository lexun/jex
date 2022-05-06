defmodule Scenario.MoxTest.MyDep do
  use Jex.GenerateBehaviour

  @spec identify :: String.t()
  def identify() do
    "MyDep"
  end
end

defmodule Scenario.MoxTest.TestResolver do
  use Jex.Resolver

  alias Jex.TestServer

  alias Scenario.MoxTest
  alias Scenario.MoxTest.MyDep

  Mox.defmock(MoxTest.DepOneMock, for: MyDep)

  @impl Jex.Resolver
  def resolve(target) do
    case TestServer.fetch(target) do
      {:ok, override} -> override
      :error -> default(target)
    end
  end

  defp default(target) do
    case target do
      MyDep -> MoxTest.DepOneMock
      _ -> target
    end
  end
end

defmodule Scenario.MoxTest.MyModule do
  use Jex.Injector

  alias Scenario.MoxTest.TestResolver

  inject Scenario.MoxTest.MyDep, via: TestResolver

  def dep() do
    MyDep.identify()
  end
end

defmodule Jex.Scenario.MoxTest do
  use ExUnit.Case, async: false

  import Mox

  alias Scenario.MoxTest
  alias Scenario.MoxTest.{MyModule, MyDep}

  setup do
    start_supervised!(Jex.TestServer)
    :ok
  end

  test "uses the mock supplied by the resolver" do
    expect(MoxTest.DepOneMock, :identify, fn -> "Mock" end)
    assert MyModule.dep() == "Mock"
  end

  test "can override with the original target" do
    Jex.TestServer.replace(MyDep, MyDep)
    assert MyModule.dep() == "MyDep"
  end
end

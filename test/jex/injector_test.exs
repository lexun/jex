defmodule Jex.InjectorTest.Single do
  use Jex.Injector do
    alias Jex.Example.BasicDep
  end

  def dep(), do: BasicDep.identify()
end

defmodule Jex.InjectorTest.Multiple do
  use Jex.Injector do
    alias Jex.Example.BasicDep
    alias Jex.Example.BasicDepTwo, as: BasicTwo
  end

  def dep_one(), do: BasicDep.identify()
  def dep_two(), do: BasicTwo.identify()
end

defmodule Jex.InjectorTest.Dynamic do
  use Jex.Injector do
    resolve_with Jex.TestResolver, dynamic: true
    alias Jex.Example.BasicDep
  end

  def dep(), do: BasicDep.identify()
end

defmodule Jex.InjectorTest do
  use ExUnit.Case, async: false

  alias Jex.InjectorTest.{Single, Multiple, Dynamic}
  alias Jex.TestServer

  test "a single alias" do
    assert Single.dep() == "BasicDep"
  end

  test "multiple aliases" do
    assert Multiple.dep_one() == "BasicDep"
  end

  test "alias with `:as` option" do
    assert Multiple.dep_two() == "BasicDepTwo"
  end

  test "dynamic runtime resolution" do
    start_supervised!(TestServer)
    assert Dynamic.dep() == "BasicDep"
    TestServer.replace(Jex.Example.BasicDep, Jex.Example.BasicDepTwo)
    assert Dynamic.dep() == "BasicDepTwo"
  end
end

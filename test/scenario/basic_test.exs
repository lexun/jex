defmodule Scenario.BasicTest.DepOne do
  def identify() do
    "DepOne"
  end
end

defmodule Scenario.BasicTest.DepTwo do
  def identify() do
    "DepTwo"
  end
end

defmodule Scenario.BasicTest.MyModule do
  use Jex.Injector

  inject Scenario.BasicTest.DepOne, via: Jex.TestResolver

  def dep() do
    DepOne.identify()
  end
end

defmodule Scenario.BasicTest do
  use ExUnit.Case, async: false

  alias Scenario.BasicTest.{MyModule, DepOne, DepTwo}

  setup do
    start_supervised!(Jex.TestServer)
    :ok
  end

  test "defaults to the supplied target module" do
    assert MyModule.dep() == "DepOne"
  end

  test "can be overriden with another module at runtime" do
    Jex.TestServer.replace(DepOne, DepTwo)
    assert MyModule.dep() == "DepTwo"
  end

  test "can be overriden with another module using full names" do
    Jex.TestServer.replace(Scenario.BasicTest.DepOne, Scenario.BasicTest.DepTwo)
    assert MyModule.dep() == "DepTwo"
  end
end

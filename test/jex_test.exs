defmodule JexTest do
  use ExUnit.Case
  doctest Jex

  test "greets the world" do
    assert Jex.hello() == :world
  end
end

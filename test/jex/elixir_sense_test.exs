defmodule Jex.ElixirSenseTest do
  use ExUnit.Case, async: false
  import Mock

  test "active in .elixir_ls dir" do
    with_mock Mix.Project, build_path: fn -> "/project/.elixir_ls/build/test" end do
      assert Jex.ElixirSense.active?()
    end
  end

  test "inactive when not in .elixir_ls" do
    with_mock Mix.Project, build_path: fn -> "/workspace/project/_build/test" end do
      refute Jex.ElixirSense.active?()
    end
  end
end

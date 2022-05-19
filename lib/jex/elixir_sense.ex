defmodule Jex.ElixirSense do
  @moduledoc false

  def active?() do
    Mix.Project.build_path()
    |> String.contains?(".elixir_ls/build")
  end
end

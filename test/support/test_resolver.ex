defmodule Jex.TestResolver do
  @moduledoc false

  use Jex.Resolver
  alias Jex.TestServer

  def resolve(target) do
    case TestServer.fetch(target) do
      {:ok, override} -> override
      :error -> target
    end
  end
end

defmodule Jex.JumpToDefinitionTest do
  use ExUnit.Case, async: false
  import Mock

  test "jump to definition works on injected modules" do
    with_mock Jex.ElixirSense, active?: fn -> true end do
      buffer = """
      defmodule MyModule do
        use Jex.Injector do
          alias Jex.Example.BasicDep, as: Dep
        end

        def call() do
          Dep.identify()
          #    ^
        end
      end
      """

      assert %ElixirSense.Location{
               file: file_path,
               type: :function
             } = ElixirSense.definition(buffer, 7, 9)

      assert String.ends_with?(file_path, "/basic_dep.ex")
    end
  end
end

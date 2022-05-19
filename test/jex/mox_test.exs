defmodule Jex.MoxTest do
  use ExUnit.Case

  @generated_modules [Jex.MoxTest.M1, Jex.MoxTest.M2, Jex.MoxTest.M3]

  for module <- @generated_modules do
    mock = Jex.Mox.mock_for(module)
    @compile {:no_warn_undefined, {mock, :my_fn, 0}}

    defmodule module do
      use Jex.GenerateBehaviour
      @spec my_fn :: atom
      def my_fn(), do: :ok
    end
  end

  describe "create_mocks/1" do
    test "accepts one or many arguments" do
      Jex.Mox.create_mocks(Jex.MoxTest.M1)
      Jex.Mox.create_mocks([Jex.MoxTest.M2, Jex.MoxTest.M3])

      for module <- @generated_modules do
        module
        |> Jex.Mox.mock_for()
        |> Mox.stub(:my_fn, fn -> :success end)
      end

      assert Jex.MoxTest.M1Mock.my_fn() == :success
      assert Jex.MoxTest.M2Mock.my_fn() == :success
      assert Jex.MoxTest.M3Mock.my_fn() == :success
    end
  end
end

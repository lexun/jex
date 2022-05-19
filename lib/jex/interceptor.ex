defmodule Jex.Interceptor do
  @moduledoc false

  def generate(target, resolver, caller) do
    interceptor = Module.concat(resolver, target)
    functions = generate_functions(target, interceptor, resolver)
    Module.create(interceptor, functions, caller)
    interceptor
  end

  defp generate_functions(target, interceptor, resolver) do
    target.__info__(:functions)
    |> Enum.map(fn {name, arity} ->
      generate_function(target, interceptor, resolver, name, arity)
    end)
  end

  defp generate_function(target, interceptor, resolver, name, arity) do
    args = Macro.generate_arguments(arity, interceptor)

    quote do
      def unquote(name)(unquote_splicing(args)) do
        target = unquote(resolver).resolve(unquote(target))
        apply(target, unquote(name), unquote(args))
      end
    end
  end
end

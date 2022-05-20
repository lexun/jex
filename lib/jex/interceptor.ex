defmodule Jex.Interceptor do
  @moduledoc false

  @doc """
  Generates interceptor modules for dynamic runtime resolution.

  The generated interceptor modules are injected where the caller aliases a
  dependency when the resolver is `dynamic`.

  Whenver the interceptor functions are called, the resolver is invoked with the
  original target, and determines which module the call will be delegated to.
  """
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

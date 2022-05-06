defmodule Jex.Injector do
  alias Jex.Resolver

  defmacro __using__(_opts) do
    quote do
      import unquote(__MODULE__), only: [inject: 2]
    end
  end

  defmacro inject(target_node, opts) do
    {_, _, split_name} = target_node
    target = Module.concat(split_name)
    interceptor = Module.concat([Jex, Generated, target])
    resolver = opts[:via] || Resolver
    functions = generate_functions(target, interceptor, resolver)
    Module.create(interceptor, functions, __CALLER__)
    quote do: alias(unquote(interceptor))
  end

  def generate_functions(target, interceptor, resolver) do
    target.__info__(:functions)
    |> Enum.map(fn {name, arity} ->
      generate_function(target, interceptor, resolver, name, arity)
    end)
  end

  def generate_function(target, interceptor, resolver, name, arity) do
    args = Macro.generate_arguments(arity, interceptor)

    quote do
      def unquote(name)(unquote_splicing(args)) do
        target = unquote(resolver).resolve(unquote(target))
        apply(target, unquote(name), unquote(args))
      end
    end
  end
end

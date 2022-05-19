defmodule Jex.Injector do
  alias Jex.{Interceptor, Resolver}

  defstruct [:caller, :resolver, nodes: [], dynamic: false]

  defmacro __using__(do: block) do
    if Jex.ElixirSense.active?() do
      remove_configuration(block)
    else
      remap_dependencies(block, new_acc(__CALLER__))
    end
  end

  defp new_acc(caller), do: %__MODULE__{caller: caller, resolver: default_resolver()}

  defp remove_configuration({:__block__, meta, children}) do
    {:__block__, meta, Enum.reject(children, fn {marker, _, _} -> marker == :resolve_with end)}
  end

  defp remove_configuration(node), do: node

  defp remap_dependencies({:__block__, meta, children}, acc) do
    {:__block__, meta,
     children
     |> Enum.reduce(acc, &process_node/2)
     |> Map.get(:nodes)
     |> Enum.reverse()}
  end

  defp remap_dependencies({:alias, _, _} = single_node, acc) do
    single_node
    |> process_node(acc)
    |> Map.get(:nodes)
    |> hd
  end

  defp process_node({:resolve_with, _, [{_, _, resolver}]}, acc) do
    %{acc | resolver: Module.concat(resolver)}
  end

  defp process_node({:resolve_with, _, [{_, _, resolver}, opts]}, acc) do
    %{acc | resolver: Module.concat(resolver), dynamic: opts[:dynamic]}
  end

  defp process_node({:alias, meta, [target]}, acc) do
    process_node({:alias, meta, [target, []]}, acc)
  end

  defp process_node({:alias, _meta, [target, opts]}, acc) do
    resolved_target = resolve_target(target, acc)
    alias_as = opts[:as] || default_as(target)
    node = quote do: alias(unquote(resolved_target), as: unquote(alias_as))
    %{acc | nodes: [node | acc.nodes]}
  end

  defp resolve_target({marker, meta, children}, %{dynamic: false} = acc) do
    {marker, meta,
     children
     |> Module.concat()
     |> acc.resolver.resolve()}
  end

  defp resolve_target({marker, meta, children}, %{dynamic: true} = acc) do
    {marker, meta,
     children
     |> Module.concat()
     |> Interceptor.generate(acc.resolver, acc.caller)}
  end

  defp default_as(target) do
    {_, _, original_module_name} = target
    original_module_name |> List.last() |> List.wrap() |> Module.concat()
  end

  defp default_resolver() do
    Application.get_env(:jex, :resolver) || Resolver
  end
end

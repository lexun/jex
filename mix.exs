defmodule Jex.MixProject do
  use Mix.Project

  @version "0.1.0"

  def project do
    [
      app: :jex,
      version: @version,
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      elixirc_paths: elixirc_paths(Mix.env()),
      name: "Jex",
      description: "Experimental dependency injection for Elixir.",
      deps: deps(),
      docs: docs(),
      package: package()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/example", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:elixir_sense, github: "elixir-lsp/elixir_sense", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.28", only: :dev, runtime: false},
      {:mix_test_interactive, "~> 1.2", only: :dev, runtime: false},
      {:mock, "~> 0.3.0", only: :test},
      {:mox, "~> 1.0", only: :test}
    ]
  end

  defp docs do
    [
      main: "Jex.Injector",
      source_ref: "v#{@version}",
      source_url: "https://github.com/lexun/jex"
    ]
  end

  defp package() do
    [
      licenses: ["Apache-2.0"],
      maintainers: ["Luke Barbuto"],
      links: %{"GitHub" => "https://github.com/lexun/jex"}
    ]
  end
end

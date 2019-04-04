defmodule PhoenixDatatables.Mixfile do
  use Mix.Project

  def project do
    [
      app: :phoenix_datatables,
      version: "0.4.1",
      elixir: "~> 1.5",
      elixirc_paths: elixirc_paths(Mix.env),
      deps: deps(),
      docs: [main: "readme", extras: ["README.md"]],
      package: package(),
      description: description()
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    []
  end

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:ecto_sql, "~> 3.0"},
      {:ex_doc, "~> 0.16", only: :dev},
      {:plug, "~> 1.4", only: :dev}, #only used in specs/docs
      {:dialyxir, "~> 1.0.0-rc.6", only: :dev, runtime: false},
      {:jason, "~> 1.1"},
      {:credo, "~> 0.8", only: [:dev, :test], runtime: false}
    ]
  end

  defp description do
    """
    Implements a server-side API for the jQuery Datatables library. Provides
    sort, search and pagination based on parameters received in client request.
    """
  end

  defp package do
    [files: ["lib", "mix.exs", "README.md", "LICENSE"],
     maintainers: ["Jeremy Huffman"],
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/smartmetals/phoenix_datatables"}]
  end
end

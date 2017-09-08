defmodule PhoenixDatatables.Mixfile do
  use Mix.Project

  def project do
    [
      app: :phoenix_datatables,
      version: "0.0.1",
      elixir: "~> 1.4",
      deps: deps()
    ]
  end

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
      {:ecto, "~> 2.1"},
      {:ex_doc, "~> 0.16", only: :dev},
      {:plug, "~> 1.4", only: :dev}, #only used in specs/docs
      {:dialyxir, "~> 0.5", only: :dev, runtime: false},
    ]
  end
end

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
      {:ecto, "~> 2.1"}
    ]
  end
end

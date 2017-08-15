use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :phoenix_datatables_example, PhoenixDatatablesExampleWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :phoenix_datatables_example, PhoenixDatatablesExample.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: System.get_env("POSTGRES_USER") ||
            "whoami" |> System.cmd([]) |> elem(0) |> String.trim(),
  password: System.get_env("POSTGRES_PASSWORD"),

  database: "phoenix_datatables_example_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

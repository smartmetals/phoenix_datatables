defmodule PhoenixDatatablesExample.Repo do
  use Ecto.Repo,
    otp_app: :phoenix_datatables_example,
    adapter: Ecto.Adapters.Postgres
end

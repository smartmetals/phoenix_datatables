NimbleCSV.define(MyParser, separator: "\,", escape: "\"")

defmodule Seeds.NationalStockNumber do
  use Mix.Task
  alias PhoenixDatatablesExample.Repo
  alias PhoenixDatatablesExample.Stock.Item
  alias Ecto.Adapters.SQL

  @doc "Imports departments and communes from the given CSV to the database"
  def import_from_csv(csv_path) do
    Mix.Task.run "ecto.migrate", []
    Mix.Task.run "app.start", []

    for table_name <- tables_to_truncate() do
      SQL.query!(Repo, "TRUNCATE TABLE #{table_name} CASCADE")
    end

    File.stream!(Path.expand(csv_path))
    |> MyParser.parse_stream
    |> Stream.each(fn [aac, common_name, description, nsn, price, rep_office, ui] ->
      process_csv_row(
        %{aac: aac,
          common_name: common_name,
          description: description,
          nsn: nsn,
          price: price,
          rep_office: rep_office,
          ui: ui
        }
      )
    end)
    |> Stream.run
  end

  defp process_csv_row(row) do
    %Item{}
    |> Item.changeset(row)
    |> Repo.insert
  end

  defp tables_to_truncate do
    ~w(
      items
    )
  end

end

Seeds.NationalStockNumber.import_from_csv("priv/repo/nsn-extract-4-5-17.csv")

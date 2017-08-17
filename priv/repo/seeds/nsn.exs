defmodule Seeds.NationalStockNumber do
  alias PhoenixDatatablesExample.Repo
  alias PhoenixDatatablesExample.Stock.Item
  alias Ecto.Adapters.SQL

  @doc "Imports departments and communes from the given CSV to the database"
  def import_from_csv(csv_path, limit) do

    for table_name <- tables_to_truncate() do
      SQL.query!(Repo, "TRUNCATE TABLE #{table_name} CASCADE")
    end

    File.stream!(Path.expand(csv_path))
    |> Seeds.CSVParser.parse_stream
    |> Stream.take(limit)
    |> Stream.each(fn [nsn, rep_office, common_name, description, price, ui, aac] ->
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

    SQL.query!(Repo, """
      update items set unit_id=(select id from units where ui_code=items.ui);
    """)

    SQL.query!(Repo, """
      insert into categories (name) (select distinct rep_office from items);
    """)

    SQL.query!(Repo, """
      update items set category_id=(select id from categories where name=items.rep_office);
    """)
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

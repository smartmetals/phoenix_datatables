defmodule Seeds.UnitsOfIssue do
  alias PhoenixDatatablesExample.Repo
  alias PhoenixDatatablesExample.Stock.Unit
  alias Ecto.Adapters.SQL

  @doc "Imports standard NSN units of issue table from the given CSV to the database"
  def import_from_csv(csv_path, limit) do

    for table_name <- tables_to_truncate() do
      SQL.query!(Repo, "TRUNCATE TABLE #{table_name} CASCADE")
    end

    File.stream!(Path.expand(csv_path))
    |> Seeds.CSVParser.parse_stream
    |> Stream.take(limit)
    |> Stream.each(fn [ui_code, description] ->
      process_csv_row(
        %{ui_code: ui_code,
          description: description
        }
      )
    end)
    |> Stream.run

  end

  defp process_csv_row(row) do
    %Unit{}
    |> Unit.changeset(row)
    |> Repo.insert
  end

  defp tables_to_truncate do
    ~w(
      units
    )
  end

end

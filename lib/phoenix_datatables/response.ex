defmodule PhoenixDatatables.Response.Payload do
  defstruct draw: 0, recordsTotal: 0, recordsFiltered: 0, data: [%{}], error: nil
end

defmodule PhoenixDatatables.Response do
  import Ecto.Query

  alias PhoenixDatatables.Response.Payload

  def send(query, draw, total_entries, repo) do
    %Payload {
      draw: draw,
      recordsTotal: total_entries,
      recordsFiltered: total_entries(query, repo),
      data: repo.all(query),
      error: nil
    }
  end

  # credit to scrivener library: https://github.com/drewolson/scrivener_ecto/blob/master/lib/scrivener/paginater/ecto/query.ex
  def total_entries(queryable, repo) do
    total_entries =
      queryable
      |> exclude(:preload)
      |> exclude(:select)
      |> exclude(:order_by)
      |> exclude(:limit)
      |> exclude(:offset)
      |> subquery
      |> select(count("*"))
      |> repo.one

    total_entries || 0
  end
end

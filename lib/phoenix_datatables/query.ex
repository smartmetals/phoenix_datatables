defmodule PhoenixDatatables.Query do
  import Ecto.Query
  alias PhoenixDatatables.Request.Params

  def sort(%Params{order: order} = params, queryable, sortable) do
    [order] = order
    dir = cast_dir(order.dir)
    column = params.columns[order.column].data |> cast_column(sortable)
    queryable
    |> order_by([{^dir, ^column}])
  end

  defp cast_column(column_name, sortable) do
    if column_name in Enum.map(sortable, &Atom.to_string/1) do
      String.to_atom(column_name)
    else
      raise ArgumentError, "#{column_name} is not a sortable column."
    end
  end

  defp cast_dir("asc"), do: :asc
  defp cast_dir("desc"), do: :desc
  defp cast_dir(wrong), do: raise ArgumentError, "#{wrong} is not a valid sort order."

  def paginate(queryable, params) do
    length = convert_to_number_if_string(params.length)
    start = convert_to_number_if_string(params.start)

    queryable
    |> limit(^length)
    |> offset(^start)
  end

  # credit to the scrivener github: https://github.com/drewolson/scrivener_ecto/blob/master/lib/scrivener/paginater/ecto/query.ex
  def total_entries(queryable, repo) do
    total_entries =
      queryable
      |> exclude(:preload)
      |> exclude(:select)
      |> exclude(:order_by)
      |> subquery
      |> select(count("*"))
      |> repo.one

    total_entries || 0
  end

  defp convert_to_number_if_string(num) do
    case is_binary(num) do
      true ->
        {num, _} = Integer.parse(num)
        num
      false -> num
    end
  end
end

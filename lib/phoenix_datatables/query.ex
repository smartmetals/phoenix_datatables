defmodule PhoenixDatatables.Query do
<<<<<<< HEAD
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
    page_number = 2
    page_size = 10
    offset  = page_size * (page_number - 1)

    queryable
    |> limit(page_size)
    |> offset(offset)
  end
end

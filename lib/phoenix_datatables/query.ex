defmodule PhoenixDatatables.Query do
  import Ecto.Query
  alias Ecto.Query.JoinExpr
  alias PhoenixDatatables.Request.Params
  alias PhoenixDatatables.Request.Search
  alias PhoenixDatatables.Query.Attribute

  def sort(%Params{order: order} = params, queryable) do
    [order] = order
    dir = cast_dir(order.dir)
    schema = schema(queryable)
    attribute = params.columns[order.column].data |> Attribute.extract(schema)
    queryable
    |> order_relation(join_order(queryable, attribute.parent),
                      dir,
                      attribute.name)
  end

  #TODO need to generate these with macros & make configurable; maybe find
  # another way entirely
  def order_relation(queryable, 0, dir, column) do
    order_by(queryable, [t], [{^dir, field(t, ^column)}])
  end
  def order_relation(queryable, 1, dir, column) do
    order_by(queryable, [_, t], [{^dir, field(t, ^column)}])
  end
  def order_relation(queryable, 2, dir, column) do
    order_by(queryable, [_, _, t], [{^dir, field(t, ^column)}])
  end
  def order_relation(queryable, 3, dir, column) do
    order_by(queryable, [_, _, _, t], [{^dir, field(t, ^column)}])
  end
  def order_relation(queryable, 4, dir, column) do
    order_by(queryable, [_, _, _, _, t], [{^dir, field(t, ^column)}])
  end

  def sort(%Params{order: order} = params, queryable, sortable) do
    [order] = order
    dir = cast_dir(order.dir)
    column = params.columns[order.column].data |> cast_column(sortable)
    queryable
    |> order_by([{^dir, ^column}])
  end

  def join_order(schema, :query) when is_atom(schema), do: 0
  def join_order(%Ecto.Query{} = queryable, parent) do
    IO.inspect queryable
    IO.inspect parent
    Enum.find_index(queryable.joins, &(join_relation(&1) == parent)) + 1
  end

  defp join_relation(%JoinExpr{assoc: {_, relation}}), do: relation
  defp join_relation(join), do: raise "Cannot find schema for non-assoc join: #{inspect join}"

  defp schema(%Ecto.Query{} = query), do: query.from |> elem(1)
  defp schema(schema) when is_atom(schema), do: schema

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

  defp convert_to_number_if_string(num) do
    case is_binary(num) do
      true ->
        {num, _} = Integer.parse(num)
        num
      false -> num
    end
  end

  # credit to scrivener library: https://github.com/drewolson/scrivener_ecto/blob/master/lib/scrivener/paginater/ecto/query.ex
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

  def search(%Params{ search: search, columns: columns} = params, queryable) do
    search_term = "%#{search.value}%"
    schema = schema(queryable)
    queryable =
    Enum.reduce columns, queryable, fn({k, v}, acc_queryable) ->
      attribute = v.data |> Attribute.extract(schema)
      IO.inspect attribute
      acc_queryable
      |> search_relation(join_order(queryable, attribute.parent),
                      attribute,
                      search_term)
    end
    queryable
  end

  #TODO need to generate these with macros & make configurable; maybe find
  # another way entirely
  def search_relation(queryable, 0, attribute, search_term) do
    or_where(queryable, [t], fragment("CAST(? AS TEXT) ILIKE ?", field(t, ^attribute.name), ^search_term))
  end
  def search_relation(queryable, 1, attribute, search_term) do
    or_where(queryable, [_, t], fragment("CAST(? AS TEXT) ILIKE ?", field(t, ^attribute.name), ^search_term))
  end
  def search_relation(queryable, 2, attribute, search_term) do
    or_where(queryable, [_, _, t], fragment("CAST(? AS TEXT) ILIKE ?", field(t, ^attribute.name), ^search_term))
  end
  def search_relation(queryable, 3, attribute, search_term) do
    or_where(queryable, [_, _, _, t], fragment("CAST(? AS TEXT) ILIKE ?", field(t, ^attribute.name), ^search_term))
  end
  def search_relation(queryable, 4, attribute, search_term) do
    or_where(queryable, [_, _, _, _, t], fragment("CAST(? AS TEXT) ILIKE ?", field(t, ^attribute.name), ^search_term))
  end
end

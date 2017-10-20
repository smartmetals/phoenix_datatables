defmodule PhoenixDatatables.Query do
  import Ecto.Query
  use PhoenixDatatables.Query.Macros
  alias Ecto.Query.JoinExpr
  alias PhoenixDatatables.Request.Params
  alias PhoenixDatatables.Request.Column
  alias PhoenixDatatables.Request.Search
  alias PhoenixDatatables.Query.Attribute
  alias PhoenixDatatables.QueryException

  @doc """
  Add order_by clauses to the provided queryable based on the "order" params provided
  in the Datatables request.
  For some queries, `:columns` need to be passed - see documentation for `PhoenixDatatables.execute`
  for details.
  """
  def sort(queryable, params, sortable \\ nil)
  def sort(%Params{order: orders} = params, queryable, sortable) when is_list(sortable) do
    sorts =
      for order <- orders do
        with dir when is_atom(dir) <- cast_dir(order.dir),
             %Column{} = column <- params.columns[order.column],
             true <- column.orderable,
             {column, join_index} when is_number(join_index) <- cast_column(column.data, sortable) do
          {dir, column, join_index}
        end
      end
    do_sorts(queryable, sorts)
  end
  def sort(queryable, %Params{order: orders} = params, _sortable) do
    schema = schema(queryable)
    sorts =
      for order <- orders do
        with dir when is_atom(dir) <- cast_dir(order.dir),
             %Column{} = column <- params.columns[order.column],
             true <- column.orderable,
             %Attribute{} = attribute <- Attribute.extract(column.data, schema),
             join_index when is_number(join_index) <- join_order(queryable, attribute.parent) do
          {dir, attribute.name, join_index}
        end
      end
    do_sorts(queryable, sorts)
  end

  def do_sorts(queryable, sorts) do
    Enum.reduce(sorts, queryable, fn {dir, column, join_index}, queryable ->
      order_relation(queryable, join_index, dir, column)
    end)
  end

  def join_order(_, nil), do: 0
  def join_order(%Ecto.Query{} = queryable, parent) do
    case Enum.find_index(queryable.joins, &(join_relation(&1) == parent)) do
      nil -> nil
      number when is_number(number) -> number + 1
    end
  end
  def join_order(queryable, parent) do
    QueryException.raise(:join_order, """

      An attempt was made to interrogate the join structure of #{inspect queryable}
      This is not an %Ecto.Query{}. The most likely cause for this error is using
      dot-notation(e.g. 'category.name') in the column name defined in the datatables
      client config but a simple Schema (no join) is used as the underlying queryable.

      Please check the client config for the fields belonging to #{inspect parent}. If
      the required field does belong to a different parent schema, that schema needs to
      be joined in the Ecto query.

    """)
  end

  defp join_relation(%JoinExpr{assoc: {_, relation}}), do: relation
  defp join_relation(_) do
    QueryException.raise(:join_relation,"""

    PhoenixDatatables queryables with non-assoc joins must be accompanied by :columns
    options to define sortable column names and join orders.

    See docs for PhoenixDatatables.execute for more information.

    """)
  end

  defp schema(%Ecto.Query{} = query), do: check_from(query.from) |> elem(1)
  defp schema(schema) when is_atom(schema), do: schema

  defp check_from(%Ecto.SubQuery{}) do
    QueryException.raise(:schema, """

    PhoenixDatatables queryables containing subqueries must be accompanied by :columns
    options to define sortable column names and join orders.

    See docs for PhoenixDatatables.execute for more information.

    """)
  end
  defp check_from(from), do: from

  defp cast_column(column_name, sortable)
    when is_list(sortable)
         and is_tuple(hd(sortable))
         and is_atom(elem(hd(sortable), 0)) do #Keyword
    [parent | child] = String.split(column_name, ".")
    if parent in Enum.map(Keyword.keys(sortable), &Atom.to_string/1) do
      member = Keyword.fetch!(sortable, String.to_atom(parent))
      case member do
        children when is_list(children) ->
          with [child] <- child,
                [child] <- Enum.filter(Keyword.keys(children), &(Atom.to_string(&1) == child)),
                {:ok, order} when is_number(order) <- Keyword.fetch(children, child) do
            {child, order}
          else
            _ -> {:error, "#{column_name} is not a sortable column."}
          end
        order when is_number(order) -> {String.to_atom(parent), order}
      end
    else
      {:error, "#{column_name} is not a sortable column."}
    end
  end

  defp cast_column(column_name, sortable) do
    if column_name in Enum.map(sortable, &Atom.to_string/1) do
      {String.to_atom(column_name), 0}
    end
  end

  defp cast_dir("asc"), do: :asc
  defp cast_dir("desc"), do: :desc
  defp cast_dir(wrong), do: {:error, "#{wrong} is not a valid sort order."}

  @doc """
  Add offset and limit clauses to the provided queryable based on the "length" and
  "start" parameters passed in the Datatables request.
  """
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

  @doc """
  Add AND where clause to the provided queryable based on the "search" parameter passed
  in the Datatables request.
  For some queries, `:columns` need to be passed - see documentation for `PhoenixDatatables.execute`
  for details.
  """
  def search(queryable, params, options \\ []) do
    columns = options[:columns]
    do_search(queryable, params, columns)
  end
  def do_search(queryable, %Params{search: %Search{value: ""}}, _), do: queryable
  def do_search(queryable, %Params{} = params, searchable) when is_list(searchable) do
    search_term = "%#{params.search.value}%"
    dynamic = dynamic([], false)
    dynamic = Enum.reduce params.columns, dynamic, fn({_, v}, acc_dynamic) ->
      with {column, join_index} when is_number(join_index) <- v.data |> cast_column(searchable),
            true <- v.searchable do
        acc_dynamic
        |> search_relation(join_index,
                          column,
                          search_term)
      else
        _ -> acc_dynamic
      end
    end
    where(queryable, [], ^dynamic)
  end

  def do_search(queryable, %Params{search: search, columns: columns}, _searchable) do
    search_term = "%#{search.value}%"
    schema = schema(queryable)
    dynamic = dynamic([], false)
    dynamic =
      Enum.reduce columns, dynamic, fn({_, v}, acc_dynamic) ->
        with %Attribute{} = attribute <- v.data |> Attribute.extract(schema),
              true <- v.searchable do
          acc_dynamic
          |> search_relation(join_order(queryable, attribute.parent),
                          attribute.name,
                          search_term)
        else
          _ -> acc_dynamic
        end
      end
    where(queryable, [], ^dynamic)
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

defmodule PhoenixDatatables.QueryException do
  defexception [:message, :operation]

  @dialyzer {:no_return, raise: 1} #yes we know it raises

  def raise(operation, message \\ "") do
    Kernel.raise __MODULE__, [operation: operation, message: message]
  end
end

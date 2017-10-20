defmodule PhoenixDatatables do
  @moduledoc """
    Provides the `execute` function which is the primary entry-point to the library, used
    by the `Repo.fetch_datatable` function and directly by client applications.
  """

  alias PhoenixDatatables.Request
  alias PhoenixDatatables.Query
  alias PhoenixDatatables.Response
  alias PhoenixDatatables.Response.Payload
  alias Plug.Conn

  @doc """
    Prepare and execute a provided query, modified based on the params map. with the results returned in a `Payload` which
    can be encoded to json by Phoenix / Poison and consumed by the DataTables client.


    ## Options

  * `:columns` - If columns are not provided, the list of
     valid columns to use for filtering and ordering is determined by introspection of the
     Ecto query, and the attributes and associations defined in the Schemas used in that
     query. This will not always work - Ecto queries may contain subqueries or schema-less queries.
     Such queryables will need to be accompanied by `:columns` options.

     &nbsp;


     Even if the queryable uses only schemas and joins built with `assoc` there are security reasons to
     provide a `:columns` option.

     The client will provide columns
     to use for filterng and searching in its request, but client input cannot be trusted. A denial of service
     attack could be constructed by requesting search against un-indexed fields on a large table for example.
     To harden your server you could limit the on the server-side the sorting and filtering possiblities
     by specifying the columns that should be available.

     &nbsp;

     A list of valid columns that are eligibile to be used for sorting and filtering can be passed in
     a nested keyword list, where the first keyword is the table name, and second is
     the column name and query binding order.

     &nbsp;

     In the below example, the query is a simple join using assoc and could be introspected. `:columns` are
     optional.

     In the example, `columns` is bound to such a list. Here the 0 means the nsn column belongs to the `from` table,
     and there is a `category.name` field, which is the first join table in the query. In the client datatables options,
     the column :data attribute should be set to `nsn` for the first column and `category.name` for the second.

     &nbsp;

      ```
        query =
          (from item in Item,
          join: category in assoc(item, :category),
          select: %{id: item.id, item.nsn, category_name: category.name})

        columns = [nsn: 0, category: [name: 1]]

        Repo.fetch_datatable(query, params, columns)
      ```
    &nbsp;

  """
  @spec execute(Ecto.Queryable.t, Conn.params, Ecto.Repo.t, Keyword.t | nil) :: Payload.t
  def execute(query, params, repo, options \\ []) do
    params = Request.receive(params)
    total_entries = Query.total_entries(query, repo)
    filtered_query =
      query
      |> Query.sort(params, options[:columns])
      |> Query.search(params, options)
      |> Query.paginate(params)

    filtered_entries = Query.total_entries(filtered_query, repo)

    filtered_query
    |> repo.all()
    |> Response.new(params.draw, total_entries, filtered_entries)
  end

  @doc """
  Use the provided function to transform the records embeded in the
  Payload, often used in a json view for example
  to convert an Ecto schema to a plain map so it can be serialized by Poison.


     query
     |> Repo.fetch_datatable(params)
     |> PhoenixDatatables.map_payload(fn item -> %{
          nsn: item.nsn,
          category_name: item.category.name}
        end)
"""
  @spec map_payload(Payload.t, (any -> any)) :: Payload.t
  def map_payload(%Payload{} = payload, fun) when is_function(fun) do
    %Payload { payload |
      data: Enum.map(payload.data, fun)
    }
  end
end

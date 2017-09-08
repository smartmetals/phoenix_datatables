defmodule PhoenixDatatables do
  alias PhoenixDatatables.Request
  alias PhoenixDatatables.Query
  alias PhoenixDatatables.Response
  alias PhoenixDatatables.Response.Payload

  def execute(query, params, repo), do: do_execute(query, params, repo, nil)
  def execute(query, params, repo, columns), do: do_execute(query, params, repo, columns)

  defp do_execute(query, params, repo, columns) do
    params = Request.receive(params)
    total_entries = Query.total_entries(query, repo)
    filtered_query =
      params
      |> Query.sort(query, columns)
      |> Query.search(params, columns)
      |> Query.paginate(params)

    filtered_entries = Query.total_entries(filtered_query, repo)

    filtered_query
    |> repo.all()
    |> Response.new(params.draw, total_entries, filtered_entries)
  end

  def map_payload(%Payload{} = payload, fun) when is_function(fun) do
    %Payload { payload |
      data: Enum.map(payload.data, fun)
    }
  end
end

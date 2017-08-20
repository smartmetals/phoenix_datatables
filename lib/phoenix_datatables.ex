defmodule PhoenixDatatables do
  alias PhoenixDatatables.Request
  alias PhoenixDatatables.Query
  alias PhoenixDatatables.Response

  def execute(query, params, repo), do: do_execute(query, params, repo, nil)
  def execute(query, params, repo, columns), do: do_execute(query, params, repo, columns)

  defp do_execute(query, params, repo, columns) do
    params = Request.receive(params)
    params
    |> Query.sort(query, columns)
    |> Query.search(params, columns)
    |> Query.paginate(params)
    |> Response.send(params.draw, Response.total_entries(query, repo), repo)
  end
end

defmodule PhoenixDatatables do
  alias PhoenixDatatables.Request
  alias PhoenixDatatables.Query
  alias PhoenixDatatables.Response

  def execute(query, params, repo), do: do_execute(query, params, repo, nil)
  def execute(query, params, repo, sortable), do: do_execute(query, params, repo, sortable)

  defp do_execute(query, params, repo, sortable) do
    params = Request.receive(params)
    params
    |> Query.sort(query, sortable)
    |> Query.search(params)
    |> Response.send(params.draw, Response.total_entries(query, repo), repo)
  end
end

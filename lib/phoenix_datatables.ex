defmodule PhoenixDatatables do
  alias PhoenixDatatables.Request
  alias PhoenixDatatables.Query
  alias PhoenixDatatables.Response

  def execute(query, params, repo), do: do_execute(query, params, repo, nil)
  def execute(query, params, repo, sortable), do: do_execute(query, params, repo, sortable)

  defp do_execute(query, params, repo, sortable) do
    Request.receive(params)
    |> Query.search(query)
    |> Response.send(params["draw"], Response.total_entries(query), repo)
  end
end

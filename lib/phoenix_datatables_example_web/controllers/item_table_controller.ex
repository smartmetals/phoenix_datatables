defmodule PhoenixDatatablesExampleWeb.ItemTableController do
  use PhoenixDatatablesExampleWeb, :controller
  alias PhoenixDatatables
  alias PhoenixDatatablesExample.Stock.Item
  alias PhoenixDatatablesExample.Repo

  action_fallback PhoenixDatatablesExampleWeb.FallbackController

  def index(conn, params) do
    render(conn, :index, payload: PhoenixDatatables.execute(Item, params, Repo))
  end

end

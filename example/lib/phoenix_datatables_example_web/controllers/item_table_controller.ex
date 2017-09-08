defmodule PhoenixDatatablesExampleWeb.ItemTableController do
  use PhoenixDatatablesExampleWeb, :controller
  alias PhoenixDatatablesExample.Stock

  action_fallback PhoenixDatatablesExampleWeb.FallbackController

  def index(conn, params) do
    render(conn, :index, payload: Stock.items_datatable(params))
  end
end

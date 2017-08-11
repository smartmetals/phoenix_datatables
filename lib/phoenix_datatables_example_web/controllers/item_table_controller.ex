defmodule PhoenixDatatablesExampleWeb.ItemTableController do
  use PhoenixDatatablesExampleWeb, :controller

  alias PhoenixDatatablesExample.Stock
  alias PhoenixDatatablesExample.Stock.Item

  action_fallback PhoenixDatatablesExampleWeb.FallbackController

  def index(conn, _params) do
    items_tables = Stock.list_items()
    render(conn, "index.json", items_tables: items_tables)
  end

end

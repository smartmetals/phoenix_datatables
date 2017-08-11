defmodule PhoenixDatatablesExampleWeb.ItemTableController do
  use PhoenixDatatablesExampleWeb, :controller

  alias PhoenixDatatablesExample.Stock
  alias PhoenixDatatablesExample.Stock.Item

  action_fallback PhoenixDatatablesExampleWeb.FallbackController

  def index(conn, params) do
    items_tables = Stock.list_items()
    draw = params["draw"]
    IO.inspect draw
    render(conn, "index.json", items_tables: items_tables, draw: draw)
  end

end

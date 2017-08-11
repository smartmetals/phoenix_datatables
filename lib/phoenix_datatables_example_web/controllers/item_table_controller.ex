defmodule PhoenixDatatablesExampleWeb.ItemTableController do
  use PhoenixDatatablesExampleWeb, :controller

  alias PhoenixDatatablesExample.Stock

  action_fallback PhoenixDatatablesExampleWeb.FallbackController

  def index(conn, params) do
    items = Stock.list_items()
    draw = params["draw"]
    render(conn, "index.json", items: items, draw: draw)
  end

end

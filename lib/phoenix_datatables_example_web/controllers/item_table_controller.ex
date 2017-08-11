defmodule PhoenixDatatablesExampleWeb.ItemTableController do
  use PhoenixDatatablesExampleWeb, :controller

  alias PhoenixDatatablesExample.Stock

  action_fallback PhoenixDatatablesExampleWeb.FallbackController

  def index(conn, params) do
    items = Stock.list_items()
    draw = params["draw"]
    render(conn, :index, items: items, draw: draw)
  end

end

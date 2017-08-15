defmodule PhoenixDatatablesExampleWeb.ItemTableController do
  use PhoenixDatatablesExampleWeb, :controller
  alias PhoenixDatatables.Request
  alias PhoenixDatatablesExample.Stock

  action_fallback PhoenixDatatablesExampleWeb.FallbackController

  def index(conn, params) do
    items = Stock.list_items()
    request = Request.receive(params)
    render(conn, :index, items: items, draw: request.draw)
  end

end

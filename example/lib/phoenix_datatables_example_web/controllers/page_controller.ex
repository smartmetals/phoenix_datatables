defmodule PhoenixDatatablesExampleWeb.PageController do
  use PhoenixDatatablesExampleWeb, :controller

  def index(conn, _params) do
    redirect(conn, to: Routes.item_path(conn, :index))
  end
end

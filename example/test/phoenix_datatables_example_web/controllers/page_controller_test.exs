defmodule PhoenixDatatablesExampleWeb.PageControllerTest do
  use PhoenixDatatablesExampleWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert redirected_to(conn) == Routes.item_path(conn, :index)
  end
end

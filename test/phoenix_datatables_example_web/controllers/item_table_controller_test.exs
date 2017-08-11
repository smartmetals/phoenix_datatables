defmodule PhoenixDatatablesExampleWeb.ItemTableControllerTest do
  use PhoenixDatatablesExampleWeb.ConnCase

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all items_tables", %{conn: conn} do
      conn = get conn, item_table_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

end

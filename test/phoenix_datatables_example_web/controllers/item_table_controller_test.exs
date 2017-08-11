defmodule PhoenixDatatablesExampleWeb.ItemTableControllerTest do
  use PhoenixDatatablesExampleWeb.ConnCase
  alias PhoenixDatatablesExample.Factory
  alias PhoenixDatatablesExample.Stock

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all items_tables", %{conn: conn} do
      Stock.create_item(Factory.item)
      conn = get conn, item_table_path(conn, :index)
      assert json_response(conn, 200)["data"] |> List.first |> Map.get("nsn") == "NSN1"
    end
  end

end

defmodule PhoenixDatatablesExampleWeb.ItemTableControllerTest do
  use PhoenixDatatablesExampleWeb.ConnCase
  alias PhoenixDatatablesExample.Factory
  alias PhoenixDatatablesExample.Stock
  alias PhoenixDatatablesExample.Repo
  alias Ecto.Adapters.SQL

  setup %{conn: conn} do
    Seeds.Load.units()
    Stock.create_item(Factory.item)
    SQL.query!(Repo, """
    insert into categories (name) (select distinct rep_office from items);
    """)

    SQL.query!(Repo, """
    update items set category_id=(select id from categories where name=items.rep_office);
    """)

    SQL.query!(Repo, """
    update items set unit_id=(select id from units where ui_code=items.ui);
    """)
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all items_tables", %{conn: conn} do
      conn = get conn, Routes.item_table_path(conn, :index), Factory.raw_request
      assert json_response(conn, 200)["data"] |> List.first |> Map.get("nsn") == "NSN1"
    end
  end

end

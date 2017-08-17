defmodule PhoenixDatatablesExampleWeb.ItemControllerTest do
  use PhoenixDatatablesExampleWeb.ConnCase

  alias PhoenixDatatablesExample.Stock

  @create_attrs %{aac: "some aac", common_name: "some common_name", description: "some description", nsn: "some nsn", price: 120.5, rep_office: "some rep_office", ui: "some ui"}
  @update_attrs %{aac: "some updated aac", common_name: "some updated common_name", description: "some updated description", nsn: "some updated nsn", price: 456.7, rep_office: "some updated rep_office", ui: "some updated ui"}
  @invalid_attrs %{aac: nil, common_name: nil, description: nil, nsn: nil, price: nil, rep_office: nil, ui: nil}

  def fixture(:item) do
    {:ok, item} = Stock.create_item(@create_attrs)
    item
  end

  describe "index" do
    test "lists all items", %{conn: conn} do
      conn = get conn, item_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Items"
    end
  end

  describe "new item" do
    test "renders form", %{conn: conn} do
      conn = get conn, item_path(conn, :new)
      assert html_response(conn, 200) =~ "New Item"
    end
  end

  describe "create item" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, item_path(conn, :create), item: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == item_path(conn, :show, id)

      conn = get conn, item_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Item"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, item_path(conn, :create), item: @invalid_attrs
      assert html_response(conn, 200) =~ "New Item"
    end
  end

  describe "edit item" do
    setup [:create_item]

    test "renders form for editing chosen item", %{conn: conn, item: item} do
      conn = get conn, item_path(conn, :edit, item)
      assert html_response(conn, 200) =~ "Edit Item"
    end
  end

  describe "update item" do
    setup [:create_item]

    test "redirects when data is valid", %{conn: conn, item: item} do
      conn = put conn, item_path(conn, :update, item), item: @update_attrs
      assert redirected_to(conn) == item_path(conn, :show, item)

      conn = get conn, item_path(conn, :show, item)
      assert html_response(conn, 200) =~ "some updated aac"
    end

    test "renders errors when data is invalid", %{conn: conn, item: item} do
      conn = put conn, item_path(conn, :update, item), item: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Item"
    end
  end

  describe "delete item" do
    setup [:create_item]

    test "deletes chosen item", %{conn: conn, item: item} do
      conn = delete conn, item_path(conn, :delete, item)
      assert redirected_to(conn) == item_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, item_path(conn, :show, item)
      end
    end
  end

  defp create_item(_) do
    item = fixture(:item)
    {:ok, item: item}
  end
end

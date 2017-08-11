defmodule PhoenixDatatablesExample.StockTest do
  use PhoenixDatatablesExample.DataCase

  alias PhoenixDatatablesExample.Stock

  describe "items" do
    alias PhoenixDatatablesExample.Stock.Item

    @valid_attrs %{aac: "some aac", common_name: "some common_name", description: "some description", nsn: "some nsn", price: 120.5, rep_office: "some rep_office", ui: "some ui"}
    @update_attrs %{aac: "some updated aac", common_name: "some updated common_name", description: "some updated description", nsn: "some updated nsn", price: 456.7, rep_office: "some updated rep_office", ui: "some updated ui"}
    @invalid_attrs %{aac: nil, common_name: nil, description: nil, nsn: nil, price: nil, rep_office: nil, ui: nil}

    def item_fixture(attrs \\ %{}) do
      {:ok, item} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Stock.create_item()

      item
    end

    test "list_items/0 returns all items" do
      item = item_fixture()
      assert Stock.list_items() == [item]
    end

    test "get_item!/1 returns the item with given id" do
      item = item_fixture()
      assert Stock.get_item!(item.id) == item
    end

    test "create_item/1 with valid data creates a item" do
      assert {:ok, %Item{} = item} = Stock.create_item(@valid_attrs)
      assert item.aac == "some aac"
      assert item.common_name == "some common_name"
      assert item.description == "some description"
      assert item.nsn == "some nsn"
      assert item.price == 120.5
      assert item.rep_office == "some rep_office"
      assert item.ui == "some ui"
    end

    test "create_item/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Stock.create_item(@invalid_attrs)
    end

    test "update_item/2 with valid data updates the item" do
      item = item_fixture()
      assert {:ok, item} = Stock.update_item(item, @update_attrs)
      assert %Item{} = item
      assert item.aac == "some updated aac"
      assert item.common_name == "some updated common_name"
      assert item.description == "some updated description"
      assert item.nsn == "some updated nsn"
      assert item.price == 456.7
      assert item.rep_office == "some updated rep_office"
      assert item.ui == "some updated ui"
    end

    test "update_item/2 with invalid data returns error changeset" do
      item = item_fixture()
      assert {:error, %Ecto.Changeset{}} = Stock.update_item(item, @invalid_attrs)
      assert item == Stock.get_item!(item.id)
    end

    test "delete_item/1 deletes the item" do
      item = item_fixture()
      assert {:ok, %Item{}} = Stock.delete_item(item)
      assert_raise Ecto.NoResultsError, fn -> Stock.get_item!(item.id) end
    end

    test "change_item/1 returns a item changeset" do
      item = item_fixture()
      assert %Ecto.Changeset{} = Stock.change_item(item)
    end
  end
end

defmodule PhoenixDatatables.QueryTest do
  use PhoenixDatatablesExample.DataCase
  alias PhoenixDatatables.Request
  alias PhoenixDatatables.Query
  alias PhoenixDatatablesExample.Repo
  alias PhoenixDatatablesExample.Stock.Item
  alias PhoenixDatatablesExample.Factory

  @sortable [:nsn, :common_name]

  describe "sort" do
    test "appends order-by clause to a single-table, single order_by queryable request" do
      [item1, item2] = add_items()
      assert item1.id != nil
      assert item2.id != nil
      assert item2.nsn < item1.nsn

      query =
        Factory.raw_request
        |> Request.receive
        |> Query.sort(Item, @sortable)

      [ritem2, ritem1] = query |> Repo.all
      assert item1.id == ritem1.id
      assert item2.id == ritem2.id
    end
  end

  def add_items do
    item = Factory.item
    item2 = %{item | nsn: "1NSN"}
    one = insert_item! item
    two = insert_item! item2
    [one, two]
  end

  def insert_item!(item) do
    cs = Item.changeset(%Item{}, item)
    Repo.insert!(cs)
  end
end

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

  describe "paginate" do
    test "appends appropriate paginate clauses to a single-table queryable request" do
      received_params = %{
        "_" => "1502482464715",
        "columns" =>
          %{
            "0" => %{"data" => "0", "name" => "", "orderable" => "true", "search" => %{"regex" => "false", "value" => ""}, "searchable" => "true"},
            "1" => %{"data" => "1", "name" => "", "orderable" => "true", "search" => %{"regex" => "false", "value" => ""}, "searchable" => "true"},
            "2" => %{"data" => "2", "name" => "", "orderable" => "true", "search" => %{"regex" => "false", "value" => ""}, "searchable" => "true"},
            "3" => %{"data" => "3", "name" => "", "orderable" => "true", "search" => %{"regex" => "false", "value" => ""}, "searchable" => "true"},
            "4" => %{"data" => "4", "name" => "", "orderable" => "true", "search" => %{"regex" => "false", "value" => ""}, "searchable" => "true"},
            "5" => %{"data" => "5", "name" => "", "orderable" => "true", "search" => %{"regex" => "false", "value" => ""}, "searchable" => "true"},
            "6" => %{"data" => "6", "name" => "", "orderable" => "true", "search" => %{"regex" => "false", "value" => ""}, "searchable" => "true"},
            "7" => %{"data" => "7", "name" => "", "orderable" => "true", "search" => %{"regex" => "false", "value" => ""}, "searchable" => "true"}
          },
        "draw" => "1",
        "length" => "10",
        "order" => %{"0" => %{"column" => "0", "dir" => "asc"}},
        "search" => %{"regex" => "false", "value" => ""},
        "start" => "0"
      }
      query = Query.paginate(Item, Request.receive(received_params))
      [{length, _}] = query.limit.params
      assert length == String.to_integer(received_params["length"])
      [{offset, _}] = query.offset.params
      assert offset == String.to_integer(received_params["start"])
    end
  end

  describe "total_entries" do
    test "returns the total number of entries in the table" do
      items = add_items()
      assert Query.total_entries(Item, Repo) == length(items)
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

defmodule PhoenixDatatablesTest do
  use PhoenixDatatablesExample.DataCase
  alias PhoenixDatatables
  alias PhoenixDatatables.Response.Payload
  alias PhoenixDatatablesExample.Repo
  alias PhoenixDatatablesExample.Stock.Item
  alias PhoenixDatatablesExample.Stock.Category
  alias PhoenixDatatablesExample.Factory

  @sortable [:nsn, :common_name]
  @sortable_join [nsn: 0, category: [name: 1]]

  describe "execute" do
    test "do all of the things in phoenix datatables" do
      { request, query } = create_request_and_query()
      assert %Payload{
        data: _data,
        draw: _draw,
        error: _error,
        recordsFiltered: _recordsFiltered,
        recordsTotal: _recordsTotal
      } = PhoenixDatatables.execute(query, request, Repo)
    end

    test "do all of the things in phoenix datatables with @sortable" do
      { request, query } = create_request_and_query()
      assert %Payload{
        data: _data,
        draw: _draw,
        error: _error,
        recordsFiltered: _recordsFiltered,
        recordsTotal: _recordsTotal
      } = PhoenixDatatables.execute(query, request, Repo, @sortable)
    end

    test "do all of the things in phoenix datatables with @sortable_join" do
      { request, query } = create_request_and_query()
      assert %Payload{
        data: _data,
        draw: _draw,
        error: _error,
        recordsFiltered: _recordsFiltered,
        recordsTotal: _recordsTotal
      } = PhoenixDatatables.execute(query, request, Repo, @sortable_join)
    end
  end

  def create_request_and_query do
    add_items()
    request = Factory.raw_request
      |> Map.put("order", %{"0" => %{"column" => "7", "dir" => "asc"}})
      |> Map.put("search", %{"regex" => "false", "value" => "1NSN"})
    query =
      (from item in Item,
        join: category in assoc(item, :category),
        select: %{id: item.id, category_name: category.name})
    {request, query}
  end

  def add_items do
    category_a = insert_category!("A")
    category_b = insert_category!("B")
    item = Map.put(Factory.item, :category_id, category_b.id)
    item2 = Map.put(Factory.item, :category_id, category_a.id)
    item2 = %{item2 | nsn: "1NSN"}
    one = insert_item! item
    two = insert_item! item2
    [one, two]
  end

  def insert_item!(item) do
    cs = Item.changeset(%Item{}, item)
    Repo.insert!(cs)
  end

  def insert_category!(category) do
    cs = Category.changeset(%Category{}, %{name: category})
    Repo.insert!(cs)
  end
end

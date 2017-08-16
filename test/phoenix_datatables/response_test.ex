defmodule PhoenixDatatables.ResponseTest do
  use PhoenixDatatablesExample.DataCase
  alias PhoenixDatatables.Response
  alias PhoenixDatatables.Request
  alias PhoenixDatatables.Query
  alias PhoenixDatatablesExample.Repo
  alias PhoenixDatatablesExample.Stock.Item
  alias PhoenixDatatablesExample.Stock.Category
  alias PhoenixDatatablesExample.Factory

  describe "send" do
    test "sends queried data in correct format" do
      add_items()
      query =
        (from item in Item,
          join: category in assoc(item, :category),
          select: %{id: item.id, category_name: category.name})
      request =
        Map.put(
          Factory.raw_request,
          "search",
          %{"regex" => "false", "value" => "1NSN"}
        )
        |> Request.receive

      payload = request
        |> Query.search(query)
        |> Response.send(request.draw, Item, Repo)
        |> IO.inspect
    end
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

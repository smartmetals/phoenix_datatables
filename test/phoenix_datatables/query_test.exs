defmodule PhoenixDatatables.QueryTest do
  use PhoenixDatatablesExample.DataCase
  alias PhoenixDatatablesExample.Repo
  alias PhoenixDatatablesExample.Stock.Item
  alias PhoenixDatatablesExample.Factory

  describe "sort" do
    test "appends appropriate order-by clauses to a single-table queryable request" do
      item = add_items()
      assert item.id != nil
    end
  end

  def add_items do
    cs = Item.changeset(%Item{}, Factory.item)
    Repo.insert!(cs)
  end
end

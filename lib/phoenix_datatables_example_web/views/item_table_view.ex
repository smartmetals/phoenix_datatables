defmodule PhoenixDatatablesExampleWeb.ItemTableView do
  use PhoenixDatatablesExampleWeb, :view
  alias PhoenixDatatablesExampleWeb.ItemTableView

  def render("index.json", %{items_tables: items_tables, draw: draw }) do
    %{
      draw: draw,
      recordsTotal: 1,
      recordsFiltered: 1,
      data: render_many(items_tables, ItemTableView, "item_table.json")
    }
  end

  def render("item_table.json", items_tables) do
    %{
      nsn: "hi"
    }
  end
end

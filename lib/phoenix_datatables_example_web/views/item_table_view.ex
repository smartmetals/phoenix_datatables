defmodule PhoenixDatatablesExampleWeb.ItemTableView do
  use PhoenixDatatablesExampleWeb, :view
  alias PhoenixDatatablesExampleWeb.ItemTableView

  def render("index.json", %{items_tables: items_tables}) do
    %{data: render_many(items_tables, ItemTableView, "item_table.json")}
  end
end

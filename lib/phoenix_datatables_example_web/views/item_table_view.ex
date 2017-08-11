defmodule PhoenixDatatablesExampleWeb.ItemTableView do
  use PhoenixDatatablesExampleWeb, :view
  alias PhoenixDatatables.Response

  def render("index.json", %{items: items, draw: draw }) do
    %Response {
      draw: draw,
      recordsTotal: 1,
      recordsFiltered: 1,
      data: items
    }
  end
end

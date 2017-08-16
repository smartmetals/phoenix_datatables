defmodule PhoenixDatatablesExampleWeb.ItemTableView do
  use PhoenixDatatablesExampleWeb, :view
  alias PhoenixDatatables.Response.Payload

  def render("index.json", %{items: items, draw: draw }) do
    %Payload {
      draw: draw,
      recordsTotal: 1,
      recordsFiltered: 1,
      data: Enum.map(items, &item_json/1)
    }
  end

  def item_json(item) do
    %{
      nsn: item.nsn,
      rep_office: item.rep_office,
      common_name: item.common_name,
      description: item.description,
      price: item.price,
      ui: item.ui,
      aac: item.aac
    }
  end

end

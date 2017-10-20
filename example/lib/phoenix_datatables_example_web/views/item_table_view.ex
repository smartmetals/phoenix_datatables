defmodule PhoenixDatatablesExampleWeb.ItemTableView do
  use PhoenixDatatablesExampleWeb, :view

  def render("index.json", %{payload: payload}) do
    PhoenixDatatables.map_payload(payload, &item_json/1)
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

defmodule PhoenixDatatablesExampleWeb.ItemTableView do
  use PhoenixDatatablesExampleWeb, :view
  alias PhoenixDatatables.Response.Payload

  def render("index.json", %{payload: payload}) do
    %Payload{ payload |
      data: Enum.map(payload.data, &item_json/1)
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

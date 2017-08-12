defmodule PhoenixDatatablesExampleWeb.ItemTableViewTest do
  use ExUnit.Case
  alias PhoenixDatatablesExampleWeb.ItemTableView

  @items [
    %{
      nsn: "NSN1",
      rep_office: "office1",
      common_name: "pots",
      description: "you know - pots",
      price: 12.65,
      ui: "EA",
      aac: "H"
    }
  ]

  describe "render" do
    test "sets draw parameter based on request" do
      response = ItemTableView.render("index.json", %{
        items: @items, draw: 5
      })
      assert response.draw == 5
    end

    test "includes items in response" do
      response = ItemTableView.render("index.json", %{
        items: @items, draw: 1
      })
      assert response.data |> Enum.count == 1
    end

    test "response can be encoded to json" do
      response = ItemTableView.render("index.json", %{
         items: @items, draw: 1
      })
      {result, _} = Poison.encode(response)
      assert result == :ok
    end
  end
end

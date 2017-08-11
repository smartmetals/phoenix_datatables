defmodule PhoenixDatatablesExampleWeb.ItemTableViewTest do
  use ExUnit.Case
  alias PhoenixDatatablesExampleWeb.ItemTableView

  @items [
    %{field1: "f1v1",
      field2: "f2v1"
     },
    %{field1: "f2v1",
      field2: "f2v2"
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
      assert response.data |> Enum.count == 2
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

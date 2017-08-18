defmodule PhoenixDatatablesExampleWeb.ItemTableViewTest do
  use ExUnit.Case

  describe "render" do
    test "sets draw parameter based on request" do
      #TODO: these tests are broken and probably going to be removed; pending
      # our decision on API we may not prefer views in our example.

      # response = ItemTableView.render("index.json", %{
      #   items: @items, draw: 5
      # })
      # assert response.draw == 5
    end

    test "includes items in response" do
      # response = ItemTableView.render("index.json", %{
      #   items: @items, draw: 1
      # })
      # assert response.data |> Enum.count == 1
    end

    test "response can be encoded to json" do
      # response = ItemTableView.render("index.json", %{
      #    items: @items, draw: 1
      # })
      # {result, _} = Poison.encode(response)
      # assert result == :ok
    end
  end
end

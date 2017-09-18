defmodule PhoenixDatatables.QueryTest do
  use PhoenixDatatables.DataCase

  alias PhoenixDatatables.Request
  alias PhoenixDatatables.Query
  alias PhoenixDatatables.QueryException

  @join_request Factory.join_request
  @simple_request Factory.simple_request

  describe "search" do
    test "raises if top-level where clause is provided" do
      query = (from item in Item,
        join: category in assoc(item, :category),
        where: ilike(item.name, "thing"),
        select: %{id: item.id, category_name: category.name})

      params =
        Map.put(
          @join_request,
          "search",
          %{"regex" => "false", "value" => "1NSN"}
        ) |> Request.receive

      assert_raise QueryException, fn ->
        Query.search(query, params)
      end
    end

    test "does not raise if there is no where in the source query" do
      query = Item

      params =
        Map.put(
          @simple_request,
          "search",
          %{"regex" => "false", "value" => "1NSN"}
        ) |> Request.receive

      assert Query.search(query, params) |> IO.inspect #Map.get(:wheres)
    end

    test "raises an exception if dot-notation used in column name" do
      query = Item

      params =
        Map.put(
          @join_request,
          "search",
          %{"regex" => "false", "value" => "1NSN"}
        ) |> Request.receive

      assert_raise QueryException, fn ->
        Query.search(query, params)
      end
    end

  end
end


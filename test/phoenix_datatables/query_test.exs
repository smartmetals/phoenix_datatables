defmodule PhoenixDatatables.QueryTest do
  use PhoenixDatatables.DataCase

  alias PhoenixDatatables.Request
  alias PhoenixDatatables.Query
  alias PhoenixDatatables.QueryException

  @join_request Factory.join_request

  describe "search" do
    test "raises an exception if dot-notation used in column name for simple queryable" do
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

    test "raises an exception when no columns accompany a query with subqueries" do

      query = from item in subquery(Item),
        join: category in assoc(item, :category),
        join: unit in assoc(item, :units)

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

    test "raises an exception when no columns accompany join without assoc" do

      query = from item in Item,
        join: subitem in subquery(Item), on: subitem.id == item.id,
        join: category in assoc(item, :category),
        join: unit in assoc(item, :units)

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


defmodule PhoenixDatatables.QueryTest do
  use PhoenixDatatables.DataCase

  alias PhoenixDatatables.Request
  alias PhoenixDatatables.Query
  alias PhoenixDatatables.QueryException

  @join_request Factory.join_request

  describe "search" do
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


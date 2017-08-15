defmodule PhoenixDatatables.RequestTest do
  use ExUnit.Case
  use PhoenixDatatablesExampleWeb.ConnCase
  alias PhoenixDatatables.Request

  describe "request" do
    test "receive/1 converts json params to struct form" do
      received_params = %{
        "_" => "1502482464715",
        "columns" =>
          %{
            "0" => %{"data" => "0", "name" => "", "orderable" => "true", "search" => %{"regex" => "false", "value" => ""}, "searchable" => "true"},
            "1" => %{"data" => "1", "name" => "", "orderable" => "true", "search" => %{"regex" => "false", "value" => ""}, "searchable" => "true"},
            "2" => %{"data" => "2", "name" => "", "orderable" => "true", "search" => %{"regex" => "false", "value" => ""}, "searchable" => "true"},
            "3" => %{"data" => "3", "name" => "", "orderable" => "true", "search" => %{"regex" => "false", "value" => ""}, "searchable" => "true"},
            "4" => %{"data" => "4", "name" => "", "orderable" => "true", "search" => %{"regex" => "false", "value" => ""}, "searchable" => "true"},
            "5" => %{"data" => "5", "name" => "", "orderable" => "true", "search" => %{"regex" => "false", "value" => ""}, "searchable" => "true"},
            "6" => %{"data" => "6", "name" => "", "orderable" => "true", "search" => %{"regex" => "false", "value" => ""}, "searchable" => "true"},
            "7" => %{"data" => "7", "name" => "", "orderable" => "true", "search" => %{"regex" => "false", "value" => ""}, "searchable" => "true"}
          },
        "draw" => "1",
        "length" => "10",
        "order" => %{"0" => %{"column" => "0", "dir" => "asc"}},
        "search" => %{"regex" => "false", "value" => ""},
        "start" => "0"
      }

      received_params_json = received_params

      assert %Request.Params{
        draw: "1",
        start: "0",
        length: "10",
        search: %Request.Search{regex: "false", value: ""},
        order: [%Request.Order{column: "0", dir: "asc"}],
        columns: %{
          "0" => %Request.Column{data: "0", name: "", orderable: "true", search: %Request.Search{regex: "false", value: ""}, searchable: "true"},
          "1" => %Request.Column{data: "1", name: "", orderable: "true", search: %Request.Search{regex: "false", value: ""}, searchable: "true"},
          "2" => %Request.Column{data: "2", name: "", orderable: "true", search: %Request.Search{regex: "false", value: ""}, searchable: "true"},
          "3" => %Request.Column{data: "3", name: "", orderable: "true", search: %Request.Search{regex: "false", value: ""}, searchable: "true"},
          "4" => %Request.Column{data: "4", name: "", orderable: "true", search: %Request.Search{regex: "false", value: ""}, searchable: "true"},
          "5" => %Request.Column{data: "5", name: "", orderable: "true", search: %Request.Search{regex: "false", value: ""}, searchable: "true"},
          "6" => %Request.Column{data: "6", name: "", orderable: "true", search: %Request.Search{regex: "false", value: ""}, searchable: "true"},
          "7" => %Request.Column{data: "7", name: "", orderable: "true", search: %Request.Search{regex: "false", value: ""}, searchable: "true"}
        }
      } = Request.receive(received_params_json)
    end
  end
end

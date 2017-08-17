defmodule PhoenixDatatablesExample.Factory do
  def item do
    %{
      nsn: "NSN1",
      rep_office: "office1",
      common_name: "pots",
      description: "you know - pots",
      price: 12.65,
      ui: "EA",
      aac: "H"
    }
  end

  def raw_request do
    %{
      "_" => "1502482464715",
      "columns" =>
        %{
          "0" => %{"data" => "nsn", "name" => "", "orderable" => "true", "search" => %{"regex" => "false", "value" => ""}, "searchable" => "true"},
          "1" => %{"data" => "rep_office", "name" => "", "orderable" => "true", "search" => %{"regex" => "false", "value" => ""}, "searchable" => "true"},
          "2" => %{"data" => "common_name", "name" => "", "orderable" => "true", "search" => %{"regex" => "false", "value" => ""}, "searchable" => "true"},
          "3" => %{"data" => "description", "name" => "", "orderable" => "true", "search" => %{"regex" => "false", "value" => ""}, "searchable" => "true"},
          "4" => %{"data" => "price", "name" => "", "orderable" => "true", "search" => %{"regex" => "false", "value" => ""}, "searchable" => "true"},
          "5" => %{"data" => "ui", "name" => "", "orderable" => "true", "search" => %{"regex" => "false", "value" => ""}, "searchable" => "true"},
          "6" => %{"data" => "aac", "name" => "", "orderable" => "true", "search" => %{"regex" => "false", "value" => ""}, "searchable" => "true"},
          "7" => %{"data" => "category.name", "name" => "", "orderable" => "true", "search" => %{"regex" => "false", "value" => ""}, "searchable" => "true"},
          "8" => %{"data" => "unit_description", "name" => "", "orderable" => "true", "search" => %{"regex" => "false", "value" => ""}, "searchable" => "true"}
        },
      "draw" => "1",
      "length" => "10",
      "order" => %{"0" => %{"column" => "0", "dir" => "asc"}},
      "search" => %{"regex" => "false", "value" => ""},
      "start" => "0"
    }
  end
end

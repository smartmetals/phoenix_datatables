defmodule PhoenixDatatables.Fixtures.Stock.Item do
  use Ecto.Schema
  alias PhoenixDatatables.Fixtures.Stock.Category
  alias PhoenixDatatables.Fixtures.Stock.Unit

  schema "items" do
    field :aac, :string
    field :common_name, :string
    field :description, :string
    field :nsn, :string
    field :price, :float
    field :rep_office, :string
    field :ui, :string
    field :nilable_field, :string
    belongs_to :category, Category
    belongs_to :unit, Unit
  end
end

defmodule PhoenixDatatables.Fixtures.Stock.Category do
  use Ecto.Schema
  alias PhoenixDatatables.Fixtures.Stock.Item

  schema "categories" do
    field :name, :string
    has_many :items, Item
  end
end

defmodule PhoenixDatatables.Fixtures.Stock.Unit do
  use Ecto.Schema
  alias PhoenixDatatables.Fixtures.Stock.Item

  schema "units" do
    field :description, :string
    field :ui_code, :string
    has_many :items, Item
  end
end

defmodule PhoenixDatatables.Fixtures.Factory do
  def join_request do
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
          "8" => %{"data" => "unit.description", "name" => "", "orderable" => "true", "search" => %{"regex" => "false", "value" => ""}, "searchable" => "true"},
          "9" => %{"data" => "nilable_field", "name" => "", "orderable" => "true", "search" => %{"regex" => "false", "value" => ""}, "searchable" => "true"}
        },
      "draw" => "1",
      "length" => "10",
      "order" => %{"0" => %{"column" => "0", "dir" => "asc"}},
      "search" => %{"regex" => "false", "value" => ""},
      "start" => "0"
    }
  end

  def simple_request do
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
          "7" => %{"data" => "category", "name" => "", "orderable" => "true", "search" => %{"regex" => "false", "value" => ""}, "searchable" => "true"},
          "8" => %{"data" => "unit", "name" => "", "orderable" => "true", "search" => %{"regex" => "false", "value" => ""}, "searchable" => "true"},
          "9" => %{"data" => "nilable_field", "name" => "", "orderable" => "true", "search" => %{"regex" => "false", "value" => ""}, "searchable" => "true"}
        },
      "draw" => "1",
      "length" => "10",
      "order" => %{"0" => %{"column" => "0", "dir" => "asc"}},
      "search" => %{"regex" => "false", "value" => ""},
      "start" => "0"
    }
  end
end

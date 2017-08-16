defmodule PhoenixDatatablesExample.Stock.Category do
  use Ecto.Schema
  import Ecto.Changeset
  alias PhoenixDatatablesExample.Stock.Category
  alias PhoenixDatatablesExample.Stock.Item


  schema "categories" do
    field :name, :string
    has_many :items, Item

  end

  @doc false
  def changeset(%Category{} = category, attrs) do
    category
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end

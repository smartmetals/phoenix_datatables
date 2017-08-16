defmodule PhoenixDatatablesExample.Stock.Item do
  use Ecto.Schema
  import Ecto.Changeset
  alias PhoenixDatatablesExample.Stock.Item
  alias PhoenixDatatablesExample.Stock.Category
  alias PhoenixDatatablesExample.Stock.Unit


  schema "items" do
    field :aac, :string
    field :common_name, :string
    field :description, :string
    field :nsn, :string
    field :price, :float
    field :rep_office, :string
    field :ui, :string
    belongs_to :category, Category
    belongs_to :unit, Unit

    timestamps()
  end

  @doc false
  def changeset(%Item{} = item, attrs) do
    item
    |> cast(attrs, [:nsn, :rep_office, :common_name, :description, :price, :ui, :aac, :category_id])
    |> validate_required([:nsn, :rep_office, :common_name, :description, :price, :ui, :aac])
  end
end

defmodule PhoenixDatatablesExample.Stock.Unit do
  use Ecto.Schema
  import Ecto.Changeset
  alias PhoenixDatatablesExample.Stock.Unit
  alias PhoenixDatatablesExample.Stock.Item


  schema "units" do
    field :description, :string
    field :ui_code, :string
    has_many :items, Item

    timestamps()
  end

  @doc false
  def changeset(%Unit{} = unit, attrs) do
    unit
    |> cast(attrs, [:ui_code, :description])
    |> validate_required([:ui_code, :description])
  end
end

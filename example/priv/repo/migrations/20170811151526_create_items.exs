defmodule PhoenixDatatablesExample.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :nsn, :string
      add :rep_office, :string
      add :common_name, :string
      add :description, :string
      add :price, :float
      add :ui, :string
      add :aac, :string

      timestamps()
    end

  end
end

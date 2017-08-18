defmodule PhoenixDatatablesExample.Repo.Migrations.CreateUnits do
  use Ecto.Migration

  def change do
    create table(:units) do
      add :ui_code, :string
      add :description, :string

      timestamps()
    end

    alter table(:items) do
      add :unit_id, references(:units)
    end

  end
end

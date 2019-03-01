defmodule PhoenixDatatablesExample.Repo.Migrations.AddNilableField do
  use Ecto.Migration

  def change do
    alter table(:items) do
      add :nilable_field, :string
    end
  end
end

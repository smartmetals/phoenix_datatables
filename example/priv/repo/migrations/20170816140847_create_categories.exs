defmodule PhoenixDatatablesExample.Repo.Migrations.CreateCategories do
  use Ecto.Migration
  alias PhoenixDatatablesExample.Repo

  def up do
    create table(:categories) do
      add :name, :string
    end

    alter table(:items) do
      add :category_id, references(:categories)
    end

    flush()

    Ecto.Adapters.SQL.query!(Repo, """
      insert into categories (name) (select distinct rep_office from items);
    """)

    Ecto.Adapters.SQL.query!(Repo, """
    update items set category_id=(select id from categories where name=items.rep_office);
    """)

  end

  def down do
    alter table(:items) do
      remove :category_id
    end
    drop table(:categories)
  end
end

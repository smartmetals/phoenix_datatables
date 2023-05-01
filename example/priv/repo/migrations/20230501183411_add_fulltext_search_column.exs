defmodule PhoenixDatatablesExample.Repo.Migrations.AddFulltextSearchColumn do
  use Ecto.Migration

  def up do
    execute("ALTER TABLE items ADD COLUMN search_text tsvector generated always AS (
      to_tsvector('english', coalesce(nsn, '')) ||
      to_tsvector('english', coalesce(aac, '')) ||
      to_tsvector('english', coalesce(common_name, '')) ||
      to_tsvector('english', coalesce(description, ''))
    ) stored;")

    execute("CREATE INDEX items_search_text ON items USING GIN (search_text);")
  end

  def down do

    execute("DROP INDEX items_search_text;")
    execute("ALTER TABLE items DROP COLUMN search_text;")
  end
end

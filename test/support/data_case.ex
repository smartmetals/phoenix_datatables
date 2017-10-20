defmodule PhoenixDatatables.DataCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      import Ecto
      import Ecto.Query
      alias PhoenixDatatables.Fixtures.Factory
      alias PhoenixDatatables.Fixtures.Stock.Category
      alias PhoenixDatatables.Fixtures.Stock.Unit
      alias PhoenixDatatables.Fixtures.Stock.Item

    end

  end

  setup do
    :ok
  end
end

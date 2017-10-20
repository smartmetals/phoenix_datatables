defmodule PhoenixDatatables.Repo do
  @moduledoc """
  Provides a using macro which creates the `fetch_table` function.

      defmodule MyApp.Repo do
        use PhoenixDatatables.Repo
      end
  """

  @doc """
  Creates the `Repo.fetch_datatable` function.
  """
  defmacro __using__(_) do
    quote do
      def fetch_datatable(query, params, columns \\ nil) do
        PhoenixDatatables.execute(query, params, __MODULE__, columns)
      end
    end
  end

end

defmodule PhoenixDatatables.Repo do

  defmacro __using__(_) do
    quote do
      def fetch_datatable(query, params, columns \\ nil) do
        PhoenixDatatables.execute(query, params, __MODULE__, columns)
      end
    end
  end

end

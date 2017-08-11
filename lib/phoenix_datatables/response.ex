defmodule PhoenixDatatables.Response do
  defstruct draw: 0, recordsTotal: 0, recordsFiltered: 0, data: [%{}], error: nil
end

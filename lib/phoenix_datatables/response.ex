defmodule PhoenixDatatables.Response.Payload do
  defstruct draw: 0, recordsTotal: 0, recordsFiltered: 0, data: [%{}], error: nil

  @type t :: %__MODULE__{}
end

defmodule PhoenixDatatables.Response do
  alias PhoenixDatatables.Response.Payload

  def new(data, draw, total_entries, filtered_entries) do
    %Payload {
      draw: draw,
      recordsTotal: total_entries,
      recordsFiltered:  filtered_entries,
      data: data,
      error: nil
    }
  end
end

defmodule PhoenixDatatables.Response.Payload do
  @moduledoc """
  A struct which serialies with `Poison` to the json response expected by the
  Datatables client library.
  """
  defstruct draw: 0,
            recordsTotal: 0,
            recordsFiltered: 0,
            data: [%{}],
            error: nil

  @type t :: %__MODULE__{}
end

defmodule PhoenixDatatables.Response do
  @moduledoc """
  Provides a Payload constructor.
  """
  alias PhoenixDatatables.Response.Payload

  @doc """
  Construct the `PhoenixDatatables.Response.Payload` based on the constituent data:

    * `:data` - A list of maps representing the query results.
    * `:recordsTotal` - The number of records available before client's requested filters are applied.
    * `:recordsFiltered` - The number of records available after client's requested filters are applied.
    * `:draw` - The draw counter received from the client is echoed back to distinguish multiple responses.

  """
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

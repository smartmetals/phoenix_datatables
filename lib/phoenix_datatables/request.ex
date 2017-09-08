defmodule PhoenixDatatables.Request.Params do
  defstruct [
    :draw,
    :start,
    :length,
    :search,
    :order,
    :columns
  ]
  @type t :: %__MODULE__{}
end

defmodule PhoenixDatatables.Request.Search do
  defstruct [
    :value,
    :regex
  ]
end

defmodule PhoenixDatatables.Request.Order do
  defstruct [
    :column,
    :dir
  ]
end

defmodule PhoenixDatatables.Request.Column do
  defstruct [
    :data,
    :name,
    :searchable,
    :orderable,
    :search
  ]
end

defmodule PhoenixDatatables.Request do
  alias PhoenixDatatables.Request.Params
  alias PhoenixDatatables.Request.Search
  alias PhoenixDatatables.Request.Order
  alias PhoenixDatatables.Request.Column

  def receive(params) do

    orders =
      for {_key, val} <- params["order"] do
        %Order{column: val["column"], dir: val["dir"]}
      end
    columns =
      Map.new (for {key, val} <- params["columns"] do
        {key, %Column{
          data: val["data"],
          name: val["name"],
          searchable: val["searchable"] == "true",
          orderable: val["orderable"] == "true",
          search: %Search{value: val["search"]["value"], regex: val["search"]["regex"]}
        } }
      end)
    search =
      %Search {
        value: params["search"]["value"],
        regex: params["search"]["regex"]
      }

    %Params{ draw: params["draw"],
             order: orders,
             search: search,
             columns: columns,
             start: params["start"] || 0,
             length: params["length"] || 10
    }
  end
end

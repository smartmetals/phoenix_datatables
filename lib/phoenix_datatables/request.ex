defmodule PhoenixDatatables.Request.Params do
  @derive [Poison.Encoder]
  defstruct [
    :draw,
    :start,
    :length,
    :search,
    :order,
    :columns
  ]
end

defmodule PhoenixDatatables.Request.Search do
  @derive [Poison.Encoder]
  defstruct [
    :value,
    :regex
  ]
end

defmodule PhoenixDatatables.Request.Order do
  @derive [Poison.Encoder]
  defstruct [
    :column,
    :dir
  ]
end

defmodule PhoenixDatatables.Request.Column do
  @derive [Poison.Encoder]
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

  import Ecto.Query

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
          searchable: val["searchable"],
          orderable: val["orderable"],
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

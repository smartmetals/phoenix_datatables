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
    decoded_params = params
    |> Poison.decode!(as: %Params{
      search: %Search{},
    })

    orders =
      for {_key, val} <- decoded_params.order do
        %Order{column: val["column"], dir: val["dir"]}
      end
    columns =
      for {_key, val} <- decoded_params.columns do
        %Column{
          data: val["data"],
          name: val["name"],
          searchable: val["searchable"],
          orderable: val["orderable"],
          search: %Search{value: val["search"]["value"], regex: val["search"]["regex"]}
        }
      end
    Map.merge(decoded_params, %{
      columns: columns,
      order: orders
    })
  end

  def send(queryable, _params, repo) do
    query = from(u in queryable)
    |> select([u], %{aac: u.aac})

    repo.all(query)
    |> Poison.encode!
  end
end

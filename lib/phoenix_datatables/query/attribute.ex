# from: https://github.com/valyukov/ex_sieve

defmodule PhoenixDatatables.Query.Attribute do
  @moduledoc false

  defstruct name: nil, parent: nil


  @type t :: %__MODULE__{}

  @spec extract(String.t, atom) :: t | {:error, :attribute_not_found}
  def extract(key, module) do
    case get_name(module, key) || get_assoc_name(module, key) do
      nil -> {:error, :attribute_not_found}
      {_assoc, nil} -> {:error, :attribute_not_found}
      {assoc, name} -> %__MODULE__{parent: assoc, name: name}
      name -> %__MODULE__{parent: nil, name: name}
    end
  end

  defp get_assoc_name(module, key) do
    case get_assoc(module, key) do
      nil ->
        nil
      assoc ->
        key = String.replace_prefix(key, "#{assoc}_", "")
        {assoc, get_name(module.__schema__(:association, assoc), key)}
    end
  end

  defp get_assoc(module, key) do
    :associations
    |> module.__schema__
    |> find_field(key)
  end

  defp get_name(%{related: module}, key) do
    get_name(module, key)
  end
  defp get_name(module, key) do
    :fields
    |> module.__schema__
    |> find_field(key)
  end

  defp find_field(fields, key) do
    fields
    |> Enum.sort_by(&String.length(to_string(&1)), &>=/2)
    |> Enum.find(&String.starts_with?(key, to_string(&1)))
  end
end

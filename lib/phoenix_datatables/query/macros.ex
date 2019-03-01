defmodule PhoenixDatatables.Query.Macros do
  @moduledoc false

  # make a simple AST representing blank Ecto table bindings so that
  # 'name' is bound to num(th) position (0 base)
  # e.g. bind_number(3, :t) = [_, _, _, t]
  defp bind_number(num, name \\ :t) do
    blanks =
      for _ <- 0..num do
        {:_, [], Elixir}
      end
    Enum.drop(blanks, 1) ++ [{name, [], Elixir}]
  end

  defp def_order_relation(num) do
    bindings = bind_number(num)
    quote do
      defp nulls_last([nulls_last: nulls_last]), do: nulls_last
      defp nulls_last(_), do: false

      defp order_relation(queryable, unquote(num), dir, column, nil) do
        order_by(queryable, unquote(bindings), [{^dir, field(t, ^column)}])
      end
      defp order_relation(queryable, unquote(num), dir, column, options) when is_list(options) do
        if dir == :desc && nulls_last(options) do
          order_by(queryable, unquote(bindings), [fragment("? DESC NULLS LAST", field(t, ^column))])
        else
          order_relation(queryable, unquote(num), dir, column, nil)
        end
      end
    end
  end

  defp def_search_relation(num) do
    bindings = bind_number(num)
    quote do
      defp search_relation(dynamic, unquote(num), attribute, search_term) do
        dynamic(unquote(bindings),
                fragment("CAST(? AS TEXT) ILIKE ?", field(t, ^attribute), ^search_term) or ^dynamic)
      end
    end
  end

  defmacro __using__(arg) do
    defines_count = case arg do
                      [] -> 25
                      num when is_integer(num) -> num
                      arg -> raise """
                                unknown args #{inspect arg} for
                                PhoenixDatatables.Query.Macros.__using__,
                                provide a number or nothing"
                              """
                    end
    order_relations = Enum.map(0..defines_count, &def_order_relation/1)
    search_relations = Enum.map(0..defines_count, &def_search_relation/1)

    quote do
      unquote(order_relations)
      defp search_relation(queryable, nil, _, _), do: queryable
      unquote(search_relations)
    end
  end

end

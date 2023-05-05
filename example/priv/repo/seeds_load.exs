NimbleCSV.define(Seeds.CSVParser, separator: "\,", escape: "\"")

defmodule Seeds.Load do
  @seeds_path Path.expand("priv/repo/seeds")
  @seeds Path.join([@seeds_path, "*.exs"])

  def init do
    for file <- Path.wildcard(@seeds) do
      Code.eval_file(file)
    end
  end

  def nsn(limit \\ 12000) do
    Seeds.NationalStockNumber.import_from_csv(Path.join([@seeds_path, "files/nsn-extract-4-5-17.csv"]), limit)
  end

  def units(limit \\ 200) do
    Seeds.UnitsOfIssue.import_from_csv(Path.join([@seeds_path, "files/units_of_issue.csv"]), limit)
  end

  def all(nsn_limit \\ 12000) do
    units()
    nsn(nsn_limit)
  end
end

Seeds.Load.init()

defmodule Seeds do
  def run do
    Mix.Task.run "ecto.migrate", []
    Mix.Task.run "app.start", []

    Code.load_file("priv/repo/seeds_load.exs")
    Seeds.Load.all()
  end

end

Seeds.run

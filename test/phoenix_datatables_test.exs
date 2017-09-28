defmodule PhoenixDatatables.Test do
  use ExUnit.Case
  describe "this library" do
    test "is also tested in the example project" do
       IO.puts "Running tests in example project:"
       {_out, rc} = System.cmd("mix", ["test"], cd: "example/", into: IO.stream(:stdio, :line))
       result = if rc == 0 do
                  "Example tests succeeded."
                else
                  "Example tests failed, please review earlier output."
                end
       assert result == "Example tests succeeded."
    end
  end
end

IO.puts "Running test in example project:"
System.cmd("mix", ["test"], cd: "example/", into: IO.stream(:stdio, :line))
ExUnit.start()

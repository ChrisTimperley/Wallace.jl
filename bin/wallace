using Wallace

println("| Wallace")
println("| A high-performance language for meta-heuristic and evolutionary computation")
println("| Documentation: http://github.io/ChrisTimperley/Wallace")
println("| Version 0.0.2-prerelease (Borneo)")
println()

while true
  print("wallace> ")

  try

    # Read the user-input and (attempt to) convert it to an expression.
    msg = parse(chomp(readline()))

    # Safely evaluate the user-input within the context of the
    # Wallace environment and record the result.
    result = eval(Wallace, msg)

    # Print the result of the expression as a string.
    println("$result")
    println()

    # Should store the result in the `ans` variable!

  # If an error occurs, output it to the terminal before continuing
  # the REPL.
  catch e
    print("ERROR: ")
    showerror(STDOUT, e)
    println()
    println()
  end
end

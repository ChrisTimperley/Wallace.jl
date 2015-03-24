# Load the Wallace kernel.
require(joinpath(dirname(@__FILE__), "kernel.jl"))

# Print the Wallace header.
println("| Wallace")
println("| A high-performance language for meta-heuristic and evolutionary computation")
println("| Documentation: http://github.io/wallace")
println("| Version 0.0.1-prerelease (Borneo)")
println()

# REPL.
while true
  print("wallace> ")

  # Attempts to read and evaluate a provided user command.
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

function benchmark(s::AbstractString, output::AbstractString, runs::Int)

  # Load the algorithm at the specified location.
  alg = compose("algorithm/simple_evolutionary_algorithm",
    Specification.load_specification(s))

  # Open up the output file.
  f = open(output, "w")
  write(f, "time\n")

  # Burn-in.
  println("Burning in...")
  run!(alg)

  println("Beginning runs...")
  for i in 1:runs
    tic()
    run!(alg)
    t = toc()
    println("Completed run $(i)/$(runs): $(t)")
    write(f, "$(t)\n")
  end

  # Close the output file.
  close(f)

end

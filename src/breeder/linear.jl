"""
TODO: Describe breeder.linear.
"""
function linear(operators::Vector{OperatorDefinition})
  # Produce a list of breeder sources definitions from the provided operator
  # definitions.
  sources = BreederSourceDefinition[selection_source("s1", operators[1])]
  for (i, op) in enumerate(operators[2:end])
    push!(sources, variation_source("s$(i+1)", "s$i", "genome", op))
  end

  # Compose as a fast breeder.
  fast(sources)
end

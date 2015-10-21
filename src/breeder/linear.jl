"""
TODO: Describe breeder.linear.
"""
function linear(operators::Vector{Operator})
  println("Building list of sources.")
  
  sources = Source[]
  sources << selection(operators[1])

  # Mark all others as variators.
  for (i, op) in enumerate(operators[2:end])
    src["source"] = "s$i"
    src["type"] = "variation"

    v = variation("s$i", op)

    haskey(src["operator"], "stage") && (src["stage"] = src["operator"]["stage"])
  end

  println("Composing sources.")
  s["sources"] = Dict{Any, Any}(
    zip(["s$i" for i in 1:length(s["sources"])], s["sources"])
  )
  println("Composed sources.")

  # Pass the modified specification to the fast breeder composer.
  compose_as(s, "breeder/fast")
end

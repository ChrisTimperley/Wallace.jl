load("../operator",  dirname(@__FILE__))

abstract Selection <: Operator

# Selects a given number of individuals from a set of candidate individuals
# according to a given selection method.
select{I <: Individual}(s::Selection, candidates::Vector{I}, n::Int64) =
  error("Unimplemented `select` method for this selection operator: $(typeof(s)).")

# Prepares this selection operator for the breeding process.
prepare{I <: Individual}(s::Selection, m::Vector{I}) = m

register("selection", Selection)

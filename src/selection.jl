module selection
using core, species, individual
export Selection, select, prepare, SelectionDefinition

"""
The base type used by all selection operator definitions.
"""
abstract SelectionDefinition

"""
The base type used by all selection operators.
"""
abstract Selection <: Operator

"""
Selects a given number of individuals from a set of candidate individuals
according to a given selection method.
"""
select{I <: Individual}(s::Selection, ::Species, ::Vector{I}, ::Integer) =
  error("Unimplemented `select` method for this selection operator: $(typeof(s)).")

"""
Prepares a given selection operator for the breeding process.
"""
prepare{I <: Individual}(s::Selection, m::Vector{I}) = m

# Load each of the selection operators.
include("selection/random.jl")
include("selection/tournament.jl")
end

module selection
importall common, species
using core
export Selection, select, SelectionDefinition

"""
The base type used by all selection operator definitions.
"""
abstract SelectionDefinition <: OperatorDefinition

"""
The base type used by all selection operators.
"""
abstract Selection <: Operator

"""
Selects a given number of individuals from a collection of candidate individuals
according to a given selection method.
"""
select(s::Selection, ::Species, ::IndividualCollection, ::Integer) =
  error("Unimplemented `select` method for this selection operator: $(typeof(s)).")

"""
Prepares a given selection operator for the breeding process.
"""
prepare(s::Selection, ic::IndividualCollection) = ic

# Load each of the selection operators.
include("selection/random.jl")
include("selection/tournament.jl")
end

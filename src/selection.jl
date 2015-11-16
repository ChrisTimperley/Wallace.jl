module selection
importall common, species
using core, fitness, individual
export Selection, select, select_ids, SelectionDefinition

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
according to a given selection method, returning the selected individuals as a
new individual collection.
"""
select(s::Selection, buffer::IndividualCollection, sp::Species, ic::IndividualCollection, n::Integer) =
  write_to_individual_collection(buffer, ic, select_ids(s, sp.fitness, indexed_fitnesses(ic), n))

"""
Selects a specified number of individuals from a list of candidates, provided
as a vector of tuples, specifying the id and fitness of each candidate.

Returns the internal IDs of the selected individuals.
"""
select_ids{F}(s::Selection, ::Species, ::Vector{Tuple{Int, F}}, ::Integer) =
  error("Unimplemented `select_ids' method for this selection operator: $(typeof(s)).") 

"""
Prepares a given selection operator for the breeding process.
"""
prepare(s::Selection, ic::IndividualCollection) = ic

# Load each of the selection operators.
include("selection/random.jl")
include("selection/tournament.jl")
end

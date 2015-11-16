"""
This module is used to define several core, abstract types, in order to keep
compilation simple, and to avoid any circular dependencies between modules.
"""
module core
export  IndividualCollection, Operator, OperatorDefinition, indexed_fitnesses,
        individuals_from_ids, write_to_individual_collection

"""
Used to hold a collection of individuals.
"""
type IndividualCollection{F}
  """
  The fitness values for each individual within this collection, indexed by
  their internal ID.
  """
  fitnesses::Vector{F}

  """
  The developmental stages for each individual within this collection. Indexed
  by the name of the stage, then by the individual's internal ID.
  """
  stages::Dict{AbstractString, Any}

  """
  Constructs a new, empty collection of individuals.
  """
  IndividualCollection() = new([], Dict())

  IndividualCollection(f::Vector{F}, s::Dict{AbstractString, Any}) = new(f, s)
end

"""
Returns a vector containing the fitness of each individual within a given
collection along with their internal ID, in the form of a tuple.
"""
indexed_fitnesses{F}(ic::IndividualCollection{F}) =
  collect(enumerate(ic.fitnesses))

"""
Composes a new collection of individuals by selecting the multi-set of
individuals in a given collection specified by a provided set of internal IDs.
"""
function individuals_from_ids{F}(from::IndividualCollection{F}, ids::Vector{Int})
  to = IndividualCollection{F}()
  to.fitnesses = [from.fitnesses[id] for id in ids]
  for stage in keys(from.stages)
    to.stages[stage] = eltype(from.stages[stage])[from.stages[stage][id] for id in ids]
  end
  to
end

function write_to_individual_collection{F}(to::IndividualCollection{F}, from::IndividualCollection{F}, ids::Vector{Int})
  # Copy fitness.
  for (i, id) in enumerate(ids)
    to.fitnesses[i] = from.fitnesses[id]
  end

  # Copy chromosomes.
  for stage in keys(from.stages)
    for (i, id) in enumerate(ids)
      to.stages[stage][i] = from.stages[stage][id]
    end
  end

  # Return modified buffer.
  to
end

"""
The base type used by all search operators.
"""
abstract Operator

"""
The base type used by all search operator definitions.
"""
abstract OperatorDefinition
end

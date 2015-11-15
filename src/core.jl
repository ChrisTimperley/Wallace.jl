"""
This module is used to define several core, abstract types, in order to keep
compilation simple, and to avoid any circular dependencies between modules.
"""
module core
export IndividualCollection, Operator, OperatorDefinition

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

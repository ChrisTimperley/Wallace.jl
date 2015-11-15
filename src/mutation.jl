"""
TODO: Document mutation module.
"""
module mutation
importall common, variation
using core, utility, representation
export Mutation, MutationDefinition

"""
The base type used by all mutation operation definitions.
"""
abstract MutationDefinition <: VariationDefinition

"""
The base type for all mutation operations.
"""
abstract Mutation <: Variation

operate!(m::Mutation, srcs::IndividualCollection, n::Int) =
  operate!(m, srcs.stages[m.stage][1:n])

# Load all mutation operations.
include("mutation/bit_flip.jl")
include("mutation/gaussian.jl")
end

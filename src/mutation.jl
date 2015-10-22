"""
TODO: Document mutation module.
"""
module mutation
importall common
using core, variation, utility, representation, individual
export Individual, Mutation, MutationDefinition

"""
The base type used by all mutation operation definitions.
"""
abstract MutationDefinition <: VariationDefinition

"""
The base type for all mutation operations.
"""
abstract Mutation <: Variation

# Load all mutation operations.
include("mutation/bit_flip.jl")
end

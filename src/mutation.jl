"""
TODO: Document mutation module.
"""
module mutation
importall common, variation
using core, utility, representation, individual
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

operate!{T}(m::Mutation, srcs::Vector{IndividualStage{T}}) =
  for src in srcs; operate!(m, src); end

"""
Performs the mutation operation on the provided individual stage provided that
it is in a valid state.
"""
operate!{T}(m::Mutation, src::IndividualStage{T}) =
  if valid(src); set(src, operate!(m, get(src))); end

# Load all mutation operations.
include("mutation/bit_flip.jl")
include("mutation/gaussian.jl")
end

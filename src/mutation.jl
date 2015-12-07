"""
TODO: Document mutation module.
"""
module mutation
import StatsBase.sample
importall common, variation
using core, utility, representation, individual, species
export Mutation, MutationDefinition, mutate!

"""
The base type used by all mutation operation definitions.
"""
abstract MutationDefinition <: VariationDefinition

"""
The base type for all mutation operations.
"""
abstract Mutation <: Variation

"""
Subjects the first `n` individuals from a provided collection to mutation,
performed using a supplied mutation operator.
"""
operate!(m::Mutation, srcs::IndividualCollection, n::Int) =
  operate!(m, srcs.stages[m.stage][1:n])

"""
Subjects a list of chromosomes to mutation, performed using a supplied mutation
operator.
"""
operate!{T}(m::Mutation, srcs::Vector{IndividualStage{T}}) =
  for src in srcs; operate!(m, src); end

"""
Performs the mutation operation on the provided individual stage provided that
it is in a valid state.
"""
operate!{T}(m::Mutation, src::IndividualStage{T}) =
  if valid(src); set(src, mutate!(m, get(src))); end

"""
All mutation operators accept a single individual.
"""
num_inputs(m::Mutation) = 1

"""
All mutation operators produce a single individual.
"""
num_outputs(m::Mutation) = 1

# Load all mutation operations.
include("mutation/null.jl")
include("mutation/bit_flip.jl")
include("mutation/gaussian.jl")
include("mutation/single_swap.jl")
include("mutation/reverse.jl")
end

"""
TODO: Document mutation module.
"""
module mutation
using core, variation, utility, representation, individual
export Individual, Mutation

"""
The base type for all mutation operations.
"""
abstract Mutation <: Variation

# Load all mutation operations.
include("mutation/bit_flip.jl")
end

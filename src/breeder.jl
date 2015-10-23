module breeder
importall common, selection, representation, mutation, variation, crossover, species
using core, utility, individual
export Breeder, BreederDefinition

"""
The base type used by all breeders.
"""
abstract Breeder

"""
The base type used by all breeder definitions.
"""
abstract BreederDefinition

# Include each of the breeders.
include("breeder/source.jl")
include("breeder/fast.jl")
include("breeder/linear.jl")
include("breeder/simple.jl")
end

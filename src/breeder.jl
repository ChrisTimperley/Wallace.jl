module breeder
using species, individual, core, variation, selection, mutation, crossover
export Breeder, BreederDefinition

abstract Breeder
abstract BreederDefinition

# Include each of the breeders.
include("breeder/source.jl")
include("breeder/fast.jl")
include("breeder/linear.jl")
include("breeder/simple.jl")
end

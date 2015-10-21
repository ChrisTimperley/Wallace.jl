module breeder
using species, individual, operator, selection, mutation, crossover
export Breeder

abstract Breeder

# Include each of the breeders.
include("breeder/source.jl")
include("breeder/fast.jl")
include("breeder/linear.jl")
include("breeder/simple.jl")
end

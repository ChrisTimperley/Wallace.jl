"""
TODO: Provide description of crossover module.
"""
module crossover
using core, variation, utility, representation, individual
export Crossover, CrossoverDefinition

"""
Base type used by all crossover operation definitions.
"""
abstract CrossoverDefinition

"""
Base type used all by crossover operators.
"""
abstract Crossover <: Variation

# Include each of the crossover operators.
include("crossover/one_point.jl")
end

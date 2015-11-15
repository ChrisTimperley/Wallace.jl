"""
TODO: Provide description of crossover module.
"""
module crossover
importall common, variation
using core, utility, representation, individual
export Crossover, CrossoverDefinition

"""
Base type used by all crossover operation definitions.
"""
abstract CrossoverDefinition <: VariationDefinition

"""
Base type used all by crossover operators.
"""
abstract Crossover <: Variation

operate!(c::Crossover, srcs::IndividualCollection, n::Int) =
  operate!(c, srcs.stages[c.stage][1:num_required(c, n)], n)

# Include each of the crossover operators.
include("crossover/one_point.jl")
end

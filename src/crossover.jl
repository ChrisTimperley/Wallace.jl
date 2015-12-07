"""
TODO: Provide description of crossover module.

RULE: Number of inputs must be greater or equal to the number of outputs.
"""
module crossover
importall common, variation
using core, utility, representation, individual, species
export Crossover, CrossoverDefinition, num_required

"""
Base type used by all crossover operation definitions.
"""
abstract CrossoverDefinition <: VariationDefinition

"""
Base type used all by crossover operators.

All crossover operators MUST implement a +stage+ property, specifying the name
of the developmental stage that this operator acts upon.
"""
abstract Crossover <: Variation

operate!(c::Crossover, srcs::IndividualCollection, n::Int) =
  operate!(c, srcs.stages[c.stage], n)

function operate!{T}(c::Crossover, srcs::Vector{IndividualStage{T}}, n::Int)
  n_in = num_inputs(c)
  n_out = num_outputs(c)
  n_calls = ceil(n / n_out)
  n_in_from = n_in_to = n_out_from = n_out_to = 0
  for i = 1:n_calls
    # Calculate range of input chromosomes.
    n_in_from = n_in_to + 1
    n_in_to = n_in_to + n_in

    # Calculate range of output chromosomes.
    n_out_from = n_out_to + 1
    n_out_to = n_out_to + n_out

    operate!(c, srcs[n_out_from:n_out_to], srcs[n_in_from:n_in_to])
  end
end

function operate!{T}(
  c::Crossover,
  outputs::Vector{IndividualStage{T}},
  inputs::Vector{IndividualStage{T}}
)
  # Ensure that all the provided inputs are in a valid state.
  # If not, leave the output buffer unchanged.
  try; operate!(c, outputs, map(get, inputs)...); end
end

"""
By default, crossover operators accept two chromosomes as input.
"""
num_inputs(::Crossover) = 2

"""
By default, crossover operators produce two chromosomes as output.
"""
num_outputs(::Crossover) = 2

"""
Calculates the number of (internal) calls required to this operator to
produce a desired number of offspring.
"""
num_calls_required(c::Crossover, n::Int) = convert(Int, ceil(n / num_outputs(c)))

"""
Calculates the number of input chromosomes required to this operator in order
to produce a specified number of offspring.
"""
num_required(c::Crossover, n::Int) = num_calls_required(c, n) * num_inputs(c)

# Include each of the crossover operators.
include("crossover/null.jl")
include("crossover/one_point.jl")
end

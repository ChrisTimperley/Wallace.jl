"""
TODO: Provide description of crossover module.

RULE: Number of inputs must be greater or equal to the number of outputs.
"""
module crossover
importall common, variation
using core, utility, representation, individual
export Crossover, CrossoverDefinition, num_require

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
  operate!(c, srcs.stages[c.stage][1:num_required(c, n)], n)

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

    operate!(c, srcs, n_out_from:n_out_to, srcs[n_from:n_to])
  end
end

function operate!{T}(
  c::Crossover,
  buffer::Vector{IndividualStage{T}},
  dest::UnitRange{Int},
  inputs::Vector{IndividualStage{T}}
)
  # Ensure that all the provided inputs are in a valid state.
  # If not, leave the output buffer unchanged.
  try
    for idx, chromo in zip(dest, operate!(c, map(get, inputs)))
      buffer[idx] = chromo
    end
  end
end

# Include each of the crossover operators.
include("crossover/one_point.jl")
end

"""
Calculates the number of (internal) calls required to this operator to
produce a desired number of offspring.
"""
num_calls_required(c::Crossover, n::Int) = ceil(n / num_outputs(c))

"""
Calculates the number of input chromosomes required to this operator in order
to produce a specified number of offspring.
"""
num_required(c::Crossover, n::Int) = num_calls_required(c, n) * num_inputs(c)

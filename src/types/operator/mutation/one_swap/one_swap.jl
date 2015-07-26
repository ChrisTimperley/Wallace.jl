load("../../mutation",            dirname(@__FILE__))
load("../../../representation",   dirname(@__FILE__))

type OneSwapMutation <: Mutation
  representation::Representation
  rate::Float

  OneSwapMutation(rep::Representation, rate::Float) =
    new(rep, rate)
end

num_inputs(o::OneSwapMutation) = 1
num_outputs(o::OneSwapMutation) = 1

function operate!{T}(o::OneSwapMutation,
  inputs::Vector{IndividualStage{Vector{T}}})

  # Enforce mutation rate.
  rand() <= o.rate && return inputs

  # Select two random points on the genome.
  p = get(inputs[0])
  ln = length(p)
  x1 = rand(1:ln)
  while true
    x2 = rand(1:ln)
    x2 != x1 && break
  end

  # Swap the chosen alleles.
  p[x1], p[x2] = p[x2], p[x1]

  return inputs
end

register(joinpath(dirname(@__FILE__), "manifest.yml"))

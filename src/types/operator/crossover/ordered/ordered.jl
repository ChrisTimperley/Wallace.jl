load("../../crossover",                                 dirname(@__FILE__))
load("../../../representation/permutation/permutation", dirname(@__FILE__))

type OrderedCrossover <: Crossover
  rep::PermutationRepresentation
  rate::Float
  length::Int
  atom::Type

  OrderedCrossover(rp::PermutationRepresentation, rt::Float) =
    new(rp, rt, rp.size, atom(rp))
end

num_inputs(o::OrderedCrossover) = 2
num_outputs(o::OrderedCrossover) = 2

function operate!{T}(o::OrderedCrossover,
  inputs::Vector{IndividualStage{Vector{T}}})

  # Enforce the crossover rate.
  rand() > o.rate && return inputs

  # Buffer the parent chromosomes.
  p1 = get(inputs[1])
  p2 = get(inputs[2])

  # Create the child chromosomes.
  c1 = Array(o.atom, o.length)
  c2 = Array(o.atom, o.length)

  # Randomly select two cut points from the parent chromosomes.
  cut_from = rand(1:o.length)
  cut_to = rand(cut_from:o.length)

  # Calculate contents of each strip.
  s1 = p1[cut_from:cut_to]
  s2 = p2[cut_from:cut_to]

  # Fill in genes for both children, in sequence.
  for i in 1:o.length
    if i >= cut_from && i <= cut_to
      c1[i] = p1[i]
      c2[i] = p2[i]
    else
      c1[i] = in(p2[i], s1) ? p1[i] : p2[i]
      c2[i] = in(p1[i], s2) ? p2[i] : p1[i]
    end
  end

  # Swap the parents with their children.
  set(inputs[1], c1)
  set(inputs[2], c2)
  return inputs
end

register(joinpath(dirname(@__FILE__), "manifest.yml"))

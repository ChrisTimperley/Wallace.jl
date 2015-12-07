"""
Provides a definition for a SingleSwap mutation operator.
"""
type SingleSwapMutationDefinition <: MutationDefinition
  stage::AbstractString
  rate::Float

  SingleSwapMutationDefinition(stage::AbstractString, rate::Float) = new(stage, rate)
end

type SingleSwapMutation <: Mutation
  stage::AbstractString
  rate::Float
  representation::Representation

  SingleSwapMutation(stage::AbstractString, rate::Float, rep::Representation) =
    new(stage, rate, rep)
end

"""
Composes a single swap mutation operator from its definition.
"""
function compose!(d::SingleSwapMutationDefinition, sp::Species)
  d.stage = d.stage == "" ? genotype(sp).label : d.stage
  SingleSwapMutation(d.stage, d.rate, sp.stages[d.stage].representation)
end

"""
Swaps the position of two randomly selected genes within a provided chromosome
with one another.

**Parameters:**

* `stage::AbstractString`, the name of the developmental stage that this
  operator should be applied to. Defaults to the genotype if no stage is
  specified.
* `rate::Float`, the probability that this operator will perform a swap upon
   invocation.
"""
single_swap() = single_swap(0.5)
single_swap(rate::Float) = single_swap("", rate)
single_swap(stage::AbstractString) = single_swap(stage, 0.5)
single_swap(stage::AbstractString, rate::Float) =
  SingleSwapMutationDefinition(stage, rate)

"""
Possibly performs a single swap mutation operation on a provided chromosome,
with a probability given by the mutation rate of the underlying operator. If the
mutation is performed, the positions of two randomly selected genes are swapped
with one another.
"""
function mutate!{T}(o::SingleSwapMutation, input::Vector{T})
  rand() < o.rate && return input

  # Perform the swap between two randomly selected genes.
  i, j = sample(1:length(input), 2, replace=false)
  input[i], input[j] = input[j], input[i]

  return input
end

"""
Provides a definition for a Twors mutation operator.
"""
type TworsMutationDefinition <: MutationDefinition
  stage::AbstractString
  rate::Float

  TworsMutationDefinition(stage::AbstractString, rate::Float) = new(stage, rate)
end

type TworsMutation <: Mutation
  stage::AbstractString
  rate::Float
  representation::Representation

  TworsMutation(stage::AbstractString, rate::Float, rep::Representation) =
    new(stage, rate, rep)
end

"""
Composes a Twors mutation operator from its definition.
"""
function compose!(d::TworsMutationDefinition, sp::Species)
  d.stage = d.stage == "" ? genotype(sp).label : d.stage
  TworsMutation(d.stage, d.rate, sp.stages[d.stage].representation)
end

"""
Swaps the position of two randomly selected genes within a provided chromosome
with one another.

For more details, see: [http://arxiv.org/pdf/1203.3099.pdf]

**Parameters:**

* `stage::AbstractString`, the name of the developmental stage that this
  operator should be applied to. Defaults to the genotype if no stage is
  specified.
* `rate::Float`, the probability that this operator will perform a swap upon
   invocation.
"""
twors() = twors(0.5)
twors(rate::Float) = twors("", rate)
twors(stage::AbstractString) = twors(stage, 0.5)
twors(stage::AbstractString, rate::Float) = TworsMutationDefinition(stage, rate)

"""
Possibly performs the Twors mutation operation on a provided chromosome, with a
probability given by the mutation rate of the underlying operator. If the
mutation is performed, the positions of two randomly selected genes are swapped
with one another.
"""
function operate!{T}(o::TworsMutation, input::Vector{T})
  rand() < o.rate && return input

  # Perform the swap between two randomly selected genes.
  i, j = sample(1:len(input), 2, replace=false)
  input[i], input[j] = input[j], input[i]

  return input
end

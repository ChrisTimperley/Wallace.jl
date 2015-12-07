"""
Provides a definition for a reverse mutation operator.
"""
type ReverseMutationDefinition <: MutationDefinition
  stage::AbstractString
  rate::Float

  ReverseMutationDefinition(stage::AbstractString, rate::Float) = new(stage, rate)
end

type ReverseMutation <: Mutation
  stage::AbstractString
  rate::Float
  representation::Representation

  ReverseMutation(stage::AbstractString, rate::Float, rep::Representation) =
    new(stage, rate, rep)
end

"""
Composes a reverse mutation operator from its definition.
"""
function compose!(d::ReverseMutationDefinition, sp::Species)
  d.stage = d.stage == "" ? genotype(sp).label : d.stage
  ReverseMutation(d.stage, d.rate, sp.stages[d.stage].representation)
end

"""
Reverses the order of all genes between two randomly selected positions, i and j,
along the chromosome.

**Parameters:**

* `stage::AbstractString`, the name of the developmental stage that this
  operator should be applied to. Defaults to the genotype if no stage is
  specified.
* `rate::Float`, the probability that this operator will perform a reverse upon
   invocation.
"""
reverse() = reverse(0.5)
reverse(rate::Float) = reverse("", rate)
reverse(stage::AbstractString) = reverse(stage, 0.5)
reverse(stage::AbstractString, rate::Float) =
  ReverseMutationDefinition(stage, rate)

"""
Possibly performs a reverse mutation operation on a provided chromosome,
with a probability given by the mutation rate of the underlying operator. If the
mutation is performed, the order of all genes within a randomly selected
sub-sequence of the given chromosome are reversed.
"""
function mutate!{T}(o::SingleSwapMutation, input::Vector{T})
  rand() < o.rate && return input

  # Perform the reverse between two randomly selected points.

  return input
end

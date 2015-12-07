type BitFlipMutationDefinition <: MutationDefinition
  stage::AbstractString
  rate::Float
  
  BitFlipMutationDefinition() = new("", 0.01)
  BitFlipMutationDefinition(rate::Float) = new("", rate)
  BitFlipMutationDefinition(stage::AbstractString) = new(stage, 0.01)
  BitFlipMutationDefinition(stage::AbstractString, rate::Float) =
    new(stage, rate)
end

type BitFlipMutation <: Mutation
  stage::AbstractString
  rate::Float
  representation::representation.BitVectorRepresentation

  BitFlipMutation(stage::AbstractString, rate::Float, rep::representation.BitVectorRepresentation) =
    new(stage, rate, rep)
end

function compose!(d::BitFlipMutationDefinition, sp::Species)
  d.stage = d.stage == "" ? genotype(sp).label : d.stage
  BitFlipMutation(d.stage, d.rate, sp.stages[d.stage].representation)
end

"""
Performs bit-flip mutation on a fixed or variable length chromosome of binary
digits, by flipping 1s to 0s and 0s to 1s at each point within the chromosome
with a given probability, equal to the mutation rate.

**Parameters:**

* `stage::AbstractString`, the name of the developmental stage that this
  operator should be applied to. Defaults to the genotype if no stage is
  specified.
* `rate::Float`, the probability of a bit flip at any given index.
  Defaults to 0.01 if no rate is provided.
"""
bit_flip() = bit_flip(0.01)
bit_flip(rate::Float) = BitFlipMutationDefinition(rate)
bit_flip(stage::AbstractString) = BitFlipMutationDefinition(stage)
bit_flip(stage::AbstractString, rate::Float) =
  BitFlipMutationDefinition(stage, rate)

function mutate!(o::BitFlipMutation, input::Vector{Int})
  for i in 1:length(input)
    if rand() <= o.rate
      input[i] = input[i] == 1 ? 0 : 1
    end
  end
  return input
end

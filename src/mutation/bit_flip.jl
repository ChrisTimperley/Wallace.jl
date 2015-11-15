type BitFlipMutationDefinition <: MutationDefinition
  rate::Float
  
  BitFlipMutationDefinition() = new(0.01)
  BitFlipMutationDefinition(rate::Float) = new(rate)
end

type BitFlipMutation <: Mutation
  rate::Float
  representation::representation.BitVectorRepresentation

  BitFlipMutation(rate::Float, rep::representation.BitVectorRepresentation) =
    new(rate, rep)
end

compose!(d::BitFlipMutationDefinition, r::Representation) =
  BitFlipMutation(d.rate, r)

"""
Performs bit-flip mutation on a fixed or variable length chromosome of binary
digits, by flipping 1s to 0s and 0s to 1s at each point within the chromosome
with a given probability, equal to the mutation rate.

**Parameters:**
* `rate::Float`, the probability of a bit flip at any given index.
"""
bit_flip() = bit_flip(0.01)
bit_flip(rate::Float) = BitFlipMutationDefinition(rate)

num_inputs(o::BitFlipMutation) = 1
num_outputs(o::BitFlipMutation) = 1

function operate!(o::BitFlipMutation, input::Vector{Int})
  for i in 1:length(input)
    if rand() <= o.rate
      input[i] = input[i] == 1 ? 0 : 1
    end
  end
  return input
end

type BitFlipMutation <: Mutation
  rate::Float
  representation::Representation.BitVectorRepresentation

  BitFlipMutation(rate::Float) = new(rate)
end

function compose!(m::BitFlipMutation, r::Representation)
  m.representation = r
  m
end

"""
Performs bit-flip mutation on a fixed or variable length chromosome of binary
digits, by flipping 1s to 0s and 0s to 1s at each point within the chromosome
with a given probability, equal to the mutation rate.

**Parameters:**
* `rate::Float`, the probability of a bit flip at any given index.
"""
bit_flip() = bit_flip(0.01)
bit_flip(rate::Float) = BitFlipMutation(rate)

num_inputs(o::BitFlipMutation) = 1
num_outputs(o::BitFlipMutation) = 1

function operate!(o::BitFlipMutation,
  inputs::Vector{IndividualStage{Vector{Int}}})
  for i in 1:length(get(inputs[1]))
    if rand() <= o.rate
      if get(inputs[1])[i] == 1
        get(inputs[1])[i] = 0
      else
        get(inputs[1])[i] = 1
      end
    end
  end
  return inputs
end
